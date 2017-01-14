#!/bin/sh
file=pause.tmp
interval=1

while true
do
    while ls $file &>/dev/null
    do
        echo "$file exists."
        sleep $interval
    done

    echo "$file not exists!"
    
    until ls $file &>/dev/null
    do
        echo "$file not exist!"
        sleep $interval
    done
    echo "$file exists."
done
