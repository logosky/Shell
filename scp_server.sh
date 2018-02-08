#!/bin/bash
function print_usage {
	printf "\033[1;30mscp server binary to test machine\n\n"
    printf "Usage:\n $0 <index> stt_dy_XX XX\n\n"
	printf "example:\n $0 1 stt_dy_treasure TreasureServer\n"
	printf "\033[0m\n"
}
if [ $# != 3 ];then
	print_usage
	exit 1
fi

DEST_PORT=22
DEST_IP="XXXX"
DEST_USER="XX"
DEST_PASS="XXX"
DEST_HOME_PATH="/home/room/XX"
WORK_PATH="/home/XX/XX"

if [ $1 == "0" ];then
    SERVER_IDX=""
else
    SERVER_IDX=$1
fi

LOACL_BINARY_PATH=${WORK_PATH}/$2/"trunk/build"/$3
DEST_PATH=${DEST_HOME_PATH}/$3${SERVER_IDX}

printf "LOACL_BINARY_PATH:\033[1;33m${LOACL_BINARY_PATH}\033[0m\n"
printf "DEST_PATH:\033[1;35m${DEST_PATH}\033[0m\n"

# check local md5
echo -ne "LOCAL MD5: \033[1;33m$(md5sum ${LOACL_BINARY_PATH} | awk '{print $1}')\033[0m\n"

# copy obj to remote
echo "COPY BINARY TO REMOTE SERVER..."
expect -c "
set timeout 300
spawn scp ${LOACL_BINARY_PATH} ${DEST_USER}@${DEST_IP}:${DEST_PATH}
expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
	\"*password*\" {sleep 0.1; send \"${DEST_PASS}\r\"; interact}
}" > /dev/null


# Show remote md5
echo "GET REMOTE MD5..."
echo -ne "\033[1;35m "
expect -c "
set timeout 300
spawn ssh -q -p${DEST_PORT} ${DEST_USER}@${DEST_IP} \"md5sum \\\"${DEST_PATH}/$3\\\"\"
expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
	\"*password*\" {sleep 0.1; send \"${DEST_PASS}\r\"; interact}
}" | tail -n 1 | awk '{print $1 "\t(REMOTE)"}'
echo -ne "\033[0m"

