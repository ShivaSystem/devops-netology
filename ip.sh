#!/bin/bash
ar_ip=(192.168.0.1 173.194.222.113 87.250.250.242)

for (( i=0; i<3; i++  ))
do
        for (( z=0; z<5; z++))
        do
                ADDR=${ar_ip[i]}
                ERRPATH='/home/shiva/netology-git/ip.sh_err.log'
                LOGPATH='/home/shiva/netology-git/ip.sh.log'
                NOTE="curl to http://$ADDR"
                curl -sSI --connect-timeout 5 http://$ADDR 2>/home/shiva/netology-git/ip.sh_err.tmp 1>/home/shiva/netology-git/ip.sh.tmp
		if (($? != 1))
                then
                        echo "$(date) - $NOTE : $(cat /tmp/ip.sh.tmp | sed -e '1p' -e '/HTTP/!d')" >> $LOGPATH
                else
                        cat /tmp/ip.sh_err.tmp | sed -e '1p' -e '/curl/!d' >> $ERRPATH
                fi
        done
done
