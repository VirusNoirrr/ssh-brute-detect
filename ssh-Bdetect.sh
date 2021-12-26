if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Please Run As Root"
    exit
fi

echo "Attempting For Any BruteForce Activity"

while true
do
    declare -A ip_attempts

    RES=$(tail -n 100 /var/log/auth.log | grep --text sshd | grep --text Failed | awk '{print $11}')
    
    for IP in $RES
    do
        if [[ -v "ip_attempts[$IP]" ]]
        then
            ip_attempts[$IP]=$((1+ip_attempts[$IP]))
        else
            ip_attempts+=([$IP]=0)
        fi
    done  


    NOW=$(date +"%T")
    for KEY in "${!ip_attempts[@]}"
    do
        if [[ ${ip_attempts[$KEY]} -ge 12 ]]
        then
            echo "[$NOW] New BruteForce activity from $KEY with ${ip_attempts[$KEY]} attempts"
        fi
    done

    unset ip_attempts
    sleep 30

done
