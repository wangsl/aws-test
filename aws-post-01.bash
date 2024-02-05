
if [[ -e /etc/parallelcluster/cfnconfig ]]; then
  source /etc/parallelcluster/cfnconfig 
else
  exit
fi

function create_user_accounts()
{
  local flag=
  if [[ "${cfn_node_type}" == "ComputeFleet" ]]; then
    flag="-M"
  fi

  local line=
  while read -r line; do
    local IFS=":"
    local line=($line)
    local netID=${line[0]}
    local uID=${line[2]}
    local gID=${line[3]}
    local name=${line[4]}
    /usr/sbin/groupadd -g ${gID} ${netID}
    /usr/sbin/useradd ${flag} -g ${gID} -s /bin/bash -u ${uID} -c "${name}" ${netID}
  done <<EOF
sw77:x:1296493:1296493:Shenglong Wang:/home/sw77:/bin/bash
wang:x:10015:10015:Shenglong Wang:/home/wang:/bin/bash
wd35:x:2761180:2761180:Wensheng Deng:/home/wd35:/bin/bash
EOF

  unset IFS

  if [[ "${cfn_node_type}" == "HeadNode" ]]; then
    local u=
    if [[ -d /scratch ]]; then
      for u in wang sw77 wd35; do
        if [[ ! -d /scratch/${u} ]]; then
          mkdir -p /scratch/${u}
          chmod 700 /scratch/${u}
          chown -Rh ${u}:${u} /scratch/${u}
        fi
      done
    fi
  fi

  /usr/sbin/groupadd -g 891200004 gaussian
  /usr/sbin/usermod -a -G wang,gaussian wang
  /usr/sbin/usermod -a -G sw77,gaussian sw77
}

function enable_gpu_profile()
{
  if [ ! -e /dev/nvidia0 ]; then return; fi
  
  if [[ "$GPU_PROFILE" != "YES" ]]; then return; fi

  cat<<EOF > /usr/local/sbin/setup-gpu-profile.bash
#!/bin/bash
set -x
#systemctl isolate multi-user
modprobe -r nvidia_uvm nvidia_drm nvidia_modeset nvidia
modprobe nvidia NVreg_RestrictProfilingToAdminUsers=0
#systemctl isolate graphical
EOF

  chmod 755 /usr/local/sbin/setup-gpu-profile.bash

  cat<<EOF > /etc/systemd/system/gpu-profile.service
[Unit]
Description=Enable GPU profile
Requires=multi-user.target

[Service]
ExecStart=/usr/local/sbin/setup-gpu-profile.bash
StandardOutput=file:/tmp/setup-gpu-profile.log
StandardError=file:/tmp/setup-gpu-profile.err
Type=oneshot
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
    
  systemctl enable gpu-profile.service
  systemctl start gpu-profile.service
}

function monitor_gpu_utilizations()
{
  if [[ ! -e /dev/nvidia0 ]]; then return; fi
    
  cat<<EOF > /etc/systemd/system/gpu-utilizations.service
[Unit]
Description=monitor GPU utilizations
Requires=multi-user.target 

[Service]
ExecStart=/usr/bin/nvidia-smi --query-gpu=index,timestamp,utilization.gpu --format=csv,nounits,noheader --loop=10
StandardOutput=append:/tmp/gpu-utilizations.log
StandardError=append:/tmp/gpu-utilizations.err
#Type=oneshot
#RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF

  systemctl enable gpu-utilizations.service
  systemctl start gpu-utilizations.service

  if [[ "$GPU_UTILIZATIONS_CHECKING" != "NO" ]]; then
    cat <(crontab -l 2> /dev/null) <(echo "*/10 * * * * /share/apps/admins/scripts/check_gpu_utilizations.bash") |  egrep -v ^$ | crontab -
  fi
}

function create_user_account()
{
  local line="<__GETENT_PASSWD__>"
  
  if [[ $line =~ ^\<__ ]]; then return; fi
  
  local flag="-M"
  
  local IFS=":"
  local line=($line)
  local netID=${line[0]}
  local uID=${line[2]}
  local gID=${line[3]}
  local name=${line[4]}
  /usr/sbin/groupadd -g ${gID} ${netID}
  /usr/sbin/useradd ${flag} -g ${gID} -s /bin/bash -u ${uID} -c "${name}" ${netID}

  unset IFS
}

function change_ssh_host_ecdsa_key()
{
  cat<<EOF > /etc/ssh/ssh_host_ecdsa_key
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIIT1MBGZpdymVEIAlqlCTUMXTMvS3Jp+tItcpJTBg3L9oAoGCCqGSM49
AwEHoUQDQgAEZr9jYvV+QqBfQh2IXn8Pxu1Pv3uWXaMmzaEuFqG6J/+qyRou3AWu
YsRDrIyREOvVegtn8XmNOBy9aaCsSoStwQ==
-----END EC PRIVATE KEY-----
EOF

  cat<<EOF > /etc/ssh/ssh_host_ecdsa_key.pub
ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGa/Y2L1fkKgX0IdiF5/D8btT797ll2jJs2hLhahuif/qskaLtwFrmLEQ6yMkRDr1XoLZ/F5jTgcvWmgrEqErcE=
EOF

  systemctl restart sshd.service
}

function gpu_initialize()
{
  if [[ ! -e /dev/nvidia0 ]]; then return; fi
    
  for((i=0; i<12; i++)); do
    if [ -x /share/apps/local/bin/p2pBandwidthLatencyTest ]; then
      /share/apps/local/bin/p2pBandwidthLatencyTest
      /usr/bin/nvidia-smi -pm 1
      break
    else
      sleep 5
    fi
  done
}

function setup_ram_disk()
{
  local ram_dir=/mnt/ram
  mkdir -p ${ram_dir}
  mount -t ramfs -o size=100M ramfs ${ram_dir}
  chmod 1777 ${ram_dir}
}

function mount_readonly_persistent_disks()
{
  local disk=
  for disk in /dev/disk/by-id/google-ro-*; do
	  local name=$(basename $disk | sed -e 's/^google-ro-//')
    local mnt_pt=/mnt/$name
    /bin/mkdir -p $mnt_pt
    /usr/bin/mount -o ro $disk $mnt_pt
  done
}

function bind_mount_share_apps()
{
  if [[ "${cfn_node_type}" == "HeadNode" ]]; then
    mkdir -p /home/apps
    chmod 2755 /home/apps
  fi
  mkdir -p /share/apps
  mount --bind /home/apps /share/apps
}

function setup_singularity()
{
  if [[ ! -e /share/apps/packages/singularity-ce-3.10.2-1.el7.x86_64.rpm ]]; then
    mkdir -p /share/apps/packages && cd /share/apps/packages
    wget https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce-3.10.2-1.el7.x86_64.rpm 
    yum install --downloadonly --downloaddir=$(pwd) runc squashfs-tools
  fi

  if [[ -e /share/apps/packages/singularity-ce-3.10.2-1.el7.x86_64.rpm ]]; then
    yum localinstall -y \
      /share/apps/packages/squashfs-tools-*.x86_64.rpm \
      /share/apps/packages/runc-*.x86_64.rpm \
      /share/apps/packages/singularity-ce-*.x86_64.rpm
  fi
}

function setup_node()
{
  if [[ "${cfn_node_type}" == "HeadNode" ]]; then
    yum update -y
    yum install -y xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps xterm emacs nano
    yum groupinstall -y "Development Tools"
    echo "X11Forwarding yes" >> /etc/ssh/sshd_config
    systemctl restart sshd
  fi

	cat<<EOF > /etc/profile.d/tz.sh
export TZ="America/New_York"
EOF

  # initialize GPU
  if [[ -e /dev/nvidia0 ]]; then
    if [[ ! -e /share/apps/local/bin/p2pBandwidthLatencyTest ]]; then
      mkdir -p /share/apps/local/bin
      wget -O /share/apps/local/bin/p2pBandwidthLatencyTest https://raw.githubusercontent.com/wangsl/aws-test/main/p2pBandwidthLatencyTest
      chmod 755 /share/apps/local/bin/p2pBandwidthLatencyTest
    fi    
    if [[ -x /share/apps/local/bin/p2pBandwidthLatencyTest ]]; then
      /share/apps/local/bin/p2pBandwidthLatencyTest
      /usr/bin/nvidia-smi -pm 1
    fi
  fi
}

function set_sshd()
{
  if [[ "${cfn_node_type}" != "ComputeFleet" ]]; then return; fi
  cat<<EOF >> /etc/ssh/sshd_config
MaxSessions 1024
MaxStartups 1024
EOF
  systemctl restart sshd
}

touch /tmp/nyu-startup.log
chmod 644 /tmp/nyu-startup.log

{
  set -x

  env 

  set_sshd

  create_user_accounts

  #bind_mount_share_apps

  #setup_singularity

  setup_node

} >> /tmp/nyu-startup.log 2>&1
