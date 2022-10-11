#!/bin/bash

tmp=($(/usr/bin/uptime | sed -e 's/,/ /g' | awk '{print $(NF-2) " " $(NF-1) " " $NF }'))

load5=${tmp[0]}
load10=${tmp[1]}
load15=${tmp[2]}

criterion=0.8

if [[ $(echo "${load5} < ${criterion} && ${load10} < ${criterion} && ${load15} < ${criterion}" | /usr/bin/bc) -eq 1 ]]; then
  /usr/sbin/shutdown -h
fi

# Crontab every 5 mins
# */5 * * * * bash ThiShellScript

