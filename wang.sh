

u=${USER}
ssh-keygen -t rsa -f /home/${u}/.ssh/id_rsa -q -P ""
cd /home/${u}/.ssh
cp -rp id_rsa.pub authorized_keys


chmod 700 /home/${u}/.ssh
chmod 600 /home/${u}/.ssh/*
chown -Rh ${u}:${u} /home/${u}/.ssh
