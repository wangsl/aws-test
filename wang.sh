

u=${USER}
ssh-keygen -t rsa -f /home/${u}/.ssh/id_rsa -q -P ""
cd /home/${u}/.ssh
cp -rp id_rsa.pub authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCAaeqaQDGEFnROiLdxgIWyabO70lb5KgQqXY+BsNyVtqUGjewJ77PIl7AGkRWAqVUCGOVMgRNYc1wL6x+rqqY1MNIV7n8VIgIUNlb00G/kl4w3wE3JvGzb/8zuKkv8RC+SBEnujynQUoqq+BiO1JPwWcRPpB1VpwAZirJDIB9slMEKzp5xGHRUXGgY+5/arPiChve5Rbi3EyWa3Iwb6jmxveqUMj2MrmCpfrmIKT7UEyTBn6L4s8D/V1FLTK2jec4BNa7m2lhuEagTfed6Z3bgM30+zl9Z4vjdkPebyDcBum8c36eoQgKSVLh/x+mP/dg1eJjEedeBvPGFkX7d3e4H aws-east" >> authorized_keys

chmod 700 /home/${u}/.ssh
chmod 600 /home/${u}/.ssh/*
chown -Rh ${u}:${u} /home/${u}/.ssh

