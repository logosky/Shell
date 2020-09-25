#! /bin/bash

param_num=$#

if [ $param_num -ne 1 ]; then
    echo "watch_mem \$pid"
    exit
fi

pid=$1
logfile="mem_file"_${pid}.log
echo $logfile

entry=0
mem1=0
mem2=0
interval=30
total_times=0
first_mem=0

echo interval is $interval
echo interval is $interval > $logfile

while true

do
    #cat /proc/$pid/status | grep VmRSS >> $logfile
    total_times=$[ $total_times + 1 ];
    entry=`cat /proc/$pid/status | grep VmRSS`
    mem2=`echo $entry | awk '{print $2}'`
    
    if [ $mem1 -eq 0 ]; then
        mem1=$mem2
        first_mem=$mem1
        echo set mem1=$mem1
    fi

    diff=$[$mem2-$mem1]
    total_diff=$[$mem2-$first_mem]
    total_speed=$[$total_diff / total_times]
    
    echo times:$total_times,current_mem:$entry,diff:$diff,total_diff=$total_diff,total_speed=$total_speed
    echo times:$total_times,current_mem:$entry,diff:$diff,total_diff=$total_diff,total_speed=$total_speed >> $logfile

    mem1=$mem2    
    sleep $interval 
done
