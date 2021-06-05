# Решение домашнего задания к занятию "4.1. Командная оболочка Bash: Практические навыки"
1. Значение $с будет 1+2, так как мы присваиваем в качестве значения этой переменной строку a+b
   Значение $d будет также 1+2, потому что мы присваиваем этой переменной строковое значение, только вместо $a и $b подставляются уже значения данных переменных
   Значение $e будет равно 3, потому что внутри двойных круглых скобок вычисляются арифметические выражения

2. 	


        #!/usr/bin/env bash
        a=1
        while (($a!=0))
        do
        	ping -c 1 8.8.8.8
         	a=$?
        	if (($a != 0))
       		then
           	     date >> curl.log
        	else break
              	fi
        done

3. 
        
        #!/bin/bash
        ar_ip=(192.168.0.1 173.194.222.113 87.250.250.242)

        for (( i=0; i<3; i++  ))
        do
            for (( z=0; z<5; z++))
            do
                  ADDR=${ar_ip[i]}
                  ERRPATH='/var/log/ip.sh_err.log'
                  LOGPATH='/var/log/ip.sh.log'
                  NOTE="curl to http://$ADDR"
                  curl -I --connect-timeout 5 http://$ADDR
                  if (($? == 0))
                  then
                        echo "$(date) - $NOTE : Port 80 on host $ADDR is available" >> $LOGPATH
                  else
                        echo "$(date) - $NOTE : Port 80 on host $ADDR is not available" >> $ERRPATH
                  fi
             done
         done

4. 

        #!/bin/bash
        ar_ip=(192.168.0.1 173.194.222.113 87.250.250.242)
        a=1

        while (($a!=0))
        do
            for (( i=0; i<3; i++  ))
            do
            if (($a!=0))
            then
                  for (( z=0; z<5; z++))
                  do
                        ADDR=${ar_ip[i]}
                        ERRPATH='/var/log/ip.sh_err.log'
                        LOGPATH='/var/log/ip.sh.log'
                        NOTE="curl to http://$ADDR"
                        curl -I --connect-timeout 5 http://$ADDR
                        a=$?
                        if (($a == 0))
                        then
                                echo "$(date) - $NOTE : Port 80 on host $ADDR is available" >> $LOGPATH
                                break
                        else
                                echo "$(date) - $NOTE : Port 80 on host $ADDR is not available" >> $ERRPATH
                        fi
                  done
            else break
            fi
            done
        done
~                                                                                                                               
~        
