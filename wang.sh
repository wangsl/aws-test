u=${USER}
ssh-keygen -t rsa -f /home/${u}/.ssh/id_rsa -q -P ""
cd /home/${u}/.ssh
cp -rp id_rsa.pub authorized_keys
cat<<EOF > /home/${u}/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCAaeqaQDGEFnROiLdxgIWyabO70lb5KgQqXY+BsNyVtqUGjewJ77PIl7AGkRWAqVUCGOVMgRNYc1wL6x+rqqY1MNIV7n8VIgIUNlb00G/kl4w3wE3JvGzb/8zuKkv8RC+SBEnujynQUoqq+BiO1JPwWcRPpB1VpwAZirJDIB9slMEKzp5xGHRUXGgY+5/arPiChve5Rbi3EyWa3Iwb6jmxveqUMj2MrmCpfrmIKT7UEyTBn6L4s8D/V1FLTK2jec4BNa7m2lhuEagTfed6Z3bgM30+zl9Z4vjdkPebyDcBum8c36eoQgKSVLh/x+mP/dg1eJjEedeBvPGFkX7d3e4H aws-east-2
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcZL+51w7/ugHsPT1wdfFywT+CYHKhaxzlCj1z9rmJlCqMIhJUmMVHhF9DyLHMO/t/yKPGCnpe/MxcyTm5cTt3txETgcNTBzdDQF2OH67iNd2Sj3zl9mwRNsdvAdIRTY76IDKeiVqbbEh4AkCycmS49xn9/nSsVScGUzm99Irj7jxc4Oj9uiSsWnc9tTGTCbOh9eMdbUEkavy97E6h2TPVwarZSunT7DsEd/qiEUmGtt/CsL2uUyf9iqlmhIAvaH2QE4AZzKOaZ9QtpEtLuAlHIGGXgQqdSWC8eSz8CENh/JaAGIINbVHlvQ5wO4xWnXUSHeRvkUq3pR8ab9X30RgP aws-east-1
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCVGla/XmepcYXjcNlinfObHKQICYM50UFhlHOUPlHc/cTowZ2RLRDW9uIl2VeG6v/Bbxnvfr1TMh9/eXYVI2yxPE6JCAsqls/MJV6ss34oSFbkC3c44A+LwwDt9N1Jzl+2q/jNIbR3HEcwEOaUj6bB9o3PJ3mTlMVauBQK01Ft4TcBo+gdy0U/sFCxkIZO5muy79GgxXWReDMz8MSJnBJQvZYBt3ZjkdjkC2g1vQeUhl/edX0NKp2sxjHPay3Cae+mh21eKZEyrksNwdfO5hErNsQYUVoeJHVzFWZkyDZ/7pJiT76rf+5tVyGBHBCGQ2mMsFnL3/0E4gVu9Owgz3+Zr6rERhXqnw9bS/3DIPIAv11DUjRR3CwYEoG+jka4o9yZTBO62UxMjiJweptqHEkwJxSFDP9RWnvfwrrSEYpZ/aE2xeirs7+ZPmIXe2fmLqYJ/REgZzKfFQEV+5zcI66SHf5abkoBeI6hEHBsgWyvsfmvd2LBjPcEYfGKWAifpk= wang@c-407-6-2.nyu.cluster
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnocI0B2BctfXrMa9+WBgJvSMQb1vlkGQCNyoYW2UqwclqVaGd1fZrSLSV2uoxZqRdNOi6ZvyOdF9h5PhWna/FVPsN7RjJ1f2gZTI3qboQKIV1GfBSEKqxUhNg8l1oQAGmXIDihSGThRmxZKjgiHM1qlWVhMa4oQ2lLgtCaJwv6++ZcELjQJcbLnduuUNWZW14dU69Ux87RC+Fwoqk/i7rRgpBnDzJL952rG/igITnyEUAnFYJFHbXBV7UeSDnow76Z9fyi6EaCA2vCNGHeFY98RgusI63zPqiIH9cyeGtd+NOcJ72HeH+F610Fl1A7GNpwkR6SuKPptwScAp7yUml wangsl@ITS-
EOF

chmod 700 /home/${u}/.ssh
chmod 600 /home/${u}/.ssh/*
chown -Rh ${u}:${u} /home/${u}/.ssh

cat<<EOF >> /home/${u}/.bashrc

ulimit -l unlimited
ulimit -s unlimited

alias ll='ls -ltrsF --time-style=+"%b %d %Y %H:%M:%S"'
alias ls='ls -xF'

alias myxterm='xterm -bg white -sb -sl 1024 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm0='xterm -sb -sl 1024 -fg black -bg lightgray -fn 7x13 > /dev/null 2>&1&'
alias myxterm1='xterm -sb -sl 1024  -bg antiquewhite3 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm2='xterm -sb -sl 1024 -fg green -bg darkred -fn 7x13 > /dev/null 2>&1 &'
alias myxterm3='xterm -sb -sl 1024  -bg Snow3 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm4='xterm -sb -sl 1024 -fg green -bg black -fn 7x13 > /dev/null 2>&1 &'
alias myxterm5='xterm -sb -sl 1024 -bg LavenderBlush3 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm6='xterm -sb -sl 1024 -fg blue -bg green4 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm7='xterm -sb -sl 1024 -fg white -bg maroon -fn 7x13 > /dev/null 2>&1 &'
alias myxterm8='xterm -sb -sl 1024 -fg white -bg darkred -fn 7x13 > /dev/null 2>&1 &'
alias myxterm9='xterm -sb -sl 1024 -fg red -bg grey -fn 7x13 > /dev/null 2>&1&'
alias myxterm10='xterm -sb -sl 1024 -fg green -bg darkblue -fn 7x13 > /dev/null 2>&1  &'
alias myxterm11='xterm -sb -sl 1024 -bg tan -fn 7x13 > /dev/null 2>&1 &'
alias myxterm12='xterm -sb -sl 1024 -fg blue -bg tan -fn 7x13 > /dev/null 2>&1 &'
alias myxterm13='xterm -sb -fg yellow -bg green4 -fn 7x13 > /dev/null 2>&1 &'
alias myxterm14='xterm -sb -fg green -bg darkslategray -fn 7x13 > /dev/null 2>&1 &'
alias myxterm15='xterm -sb -fg yellow -bg darkslategray -fn 7x13 > /dev/null 2>&1 &'
alias myxterm16='xterm -sb -fg black -bg peru -fn 7x13 > /dev/null 2>&1 &'
alias myxterm17='xterm -sb -fg black -bg peachpuff -fn 7x13 > /dev/null 2>&1 &'

alias myxterm20='xterm -sb -sl 1000 -fa Monaco -fs 11 > /dev/null 2>&1 &'

function _myxterm()
{
  myxterm
  myxterm
  myxterm
  myxterm1
  myxterm2
  myxterm4
}

EOF
