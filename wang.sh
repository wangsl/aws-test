u=${USER}
ssh-keygen -t rsa -f /home/${u}/.ssh/id_rsa -q -P ""
cd /home/${u}/.ssh
cp -rp id_rsa.pub authorized_keys
cat<<EOF > /home/${u}/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCAaeqaQDGEFnROiLdxgIWyabO70lb5KgQqXY+BsNyVtqUGjewJ77PIl7AGkRWAqVUCGOVMgRNYc1wL6x+rqqY1MNIV7n8VIgIUNlb00G/kl4w3wE3JvGzb/8zuKkv8RC+SBEnujynQUoqq+BiO1JPwWcRPpB1VpwAZirJDIB9slMEKzp5xGHRUXGgY+5/arPiChve5Rbi3EyWa3Iwb6jmxveqUMj2MrmCpfrmIKT7UEyTBn6L4s8D/V1FLTK2jec4BNa7m2lhuEagTfed6Z3bgM30+zl9Z4vjdkPebyDcBum8c36eoQgKSVLh/x+mP/dg1eJjEedeBvPGFkX7d3e4H aws-east-2
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcZL+51w7/ugHsPT1wdfFywT+CYHKhaxzlCj1z9rmJlCqMIhJUmMVHhF9DyLHMO/t/yKPGCnpe/MxcyTm5cTt3txETgcNTBzdDQF2OH67iNd2Sj3zl9mwRNsdvAdIRTY76IDKeiVqbbEh4AkCycmS49xn9/nSsVScGUzm99Irj7jxc4Oj9uiSsWnc9tTGTCbOh9eMdbUEkavy97E6h2TPVwarZSunT7DsEd/qiEUmGtt/CsL2uUyf9iqlmhIAvaH2QE4AZzKOaZ9QtpEtLuAlHIGGXgQqdSWC8eSz8CENh/JaAGIINbVHlvQ5wO4xWnXUSHeRvkUq3pR8ab9X30RgP aws-east-1
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCVGla/XmepcYXjcNlinfObHKQICYM50UFhlHOUPlHc/cTowZ2RLRDW9uIl2VeG6v/Bbxnvfr1TMh9/eXYVI2yxPE6JCAsqls/MJV6ss34oSFbkC3c44A+LwwDt9N1Jzl+2q/jNIbR3HEcwEOaUj6bB9o3PJ3mTlMVauBQK01Ft4TcBo+gdy0U/sFCxkIZO5muy79GgxXWReDMz8MSJnBJQvZYBt3ZjkdjkC2g1vQeUhl/edX0NKp2sxjHPay3Cae+mh21eKZEyrksNwdfO5hErNsQYUVoeJHVzFWZkyDZ/7pJiT76rf+5tVyGBHBCGQ2mMsFnL3/0E4gVu9Owgz3+Zr6rERhXqnw9bS/3DIPIAv11DUjRR3CwYEoG+jka4o9yZTBO62UxMjiJweptqHEkwJxSFDP9RWnvfwrrSEYpZ/aE2xeirs7+ZPmIXe2fmLqYJ/REgZzKfFQEV+5zcI66SHf5abkoBeI6hEHBsgWyvsfmvd2LBjPcEYfGKWAifpk= wang@c-407-6-2.nyu.cluster
EOF

chmod 700 /home/${u}/.ssh
chmod 600 /home/${u}/.ssh/*
chown -Rh ${u}:${u} /home/${u}/.ssh
