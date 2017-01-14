#!/bin/bash
function print_usage {
	printf "\033[31mUsage:\033[0m $0 <index> (t)		\033[1;30mDeploy dev so to test servers\n\n"
	printf "\033[33m"
	printf "   1 -	unit_client		->	192.168.0.1\n"
	printf "   2 -	unit_test	    ->	192.168.0.1\n"
	printf "\033[0m\n"
}
if [ $# != 1 ];then
	print_usage
	exit 1
fi

PORT=3000
USER="user"
PASS="password"
WORK_PATH="/usr/local/services"
TMP_PATH="/data/user/temp"
DEV_IP="192.168.0.2"
DEV_USER="user"
DEV_PASS="passwrod"

case "$1" in
    "1")
	HOST="192.168.0.1"
	SRC_PATH="/data/user/unit_client"
    OBJ_NAME="unit_client"
    ;;
    "2")
    printf "Not support now."
    exit 0
    ;;
esac

DEST_PATH=/home/user

printf "DEST_PATH:\033[1;33m${DEST_PATH}\033[0m\n"

# copy obj to local
expect -c "
set timeout 30
spawn scp ${DEV_USER}@${DEV_IP}:${SRC_PATH} ${TMP_PATH}/${OBJ_NAME}
expect {
	\"*yes/no*\" {send \"yes\r\"; exp_continue}
	\"*password*\" {sleep 0.1; send \"${DEV_PASS}\r\"; interact}
}" > /dev/null

echo -ne "\033[33mUPGRADE\033[0m ${DEST_PATH}/\033[32m${OBJ_NAME}033[0m\n"
echo -ne "\033[32mMD5\033[0m $(md5sum ${TMP_PATH}/${OBJ_NAME} | awk '{print $1}')\n"

# copy obj to remote
expect -c "
spawn scp ${TMP_PATH}/${OBJ_NAME} ${USER}@${HOST}:${DEST_PATH}/${OBJ_NAME}
expect {
	\"*yes/no*\" {send \"yes\r\"; exp_continue}
	\"*password*\" {sleep 0.1; send \"${PASS}\r\"; interact}
}" > /dev/null

# Show md5
echo -ne "\033[1;35mMD5\033[1;30m "
expect -c "
spawn ssh -q -p${PORT} ${USER}@${HOST} \"md5sum \\\"${DEST_PATH}/${OBJ_NAME}\\\"\"
expect {
	\"*yes/no*\" {send \"yes\r\"; exp_continue}
	\"*password*\" {sleep 0.1; send \"${PASS}\r\"; interact}
}" | tail -n 1 | awk '{print $1 "\t(server)"}'
echo -ne "\033[0m"

rm -f ${TMP_PATH}/${OBJ_NAME}

#rm -f ${TMP_PATH}/spp_path
