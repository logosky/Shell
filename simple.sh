#!/bin/bash

#!/bin/sh

function logdate
{
    date +%Y-%m-%d_%H:%M:%S
}

function WriteLog
{
    echo "[$(logdate) $0]" $@
}

print_arg(){
    echo "print arg:"$1
}

WriteLog "Test log"

args="time to test"
echo $args

echo "exit:"$?
echo "name:"$0
echo "home:"$HOME
echo "lang:"$LANG
echo "line no:"$LINENO
echo "pid:"$$
echo "ppid:"$PPID
echo "pwd:"$PWD

if [ $1 == 1 ]
then
    echo "arg 1 is 1"
elif [ $1 == 2 ]
then
    echo "arg 1 is 2"
else
    echo "arg 1 is:"$1
fi

for i in $@
do
    echo "arg :"$i
    while [ $i != 5 ]
    do
        case $i in
        1)
            echo "case:"$i
            break;
            ;;
        *)
            echo "case other:"$i
            break;
            ;;
        esac
        echo "while:"$i
    done
done

print_arg $2;

echo "please input name,addr and num:"
read name addr num
echo "name:"$name
echo "addr:"$addr
echo "num:"$num
