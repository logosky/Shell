#!/bin/bash

# 通过此脚本可以在命令行直接提交merge request
# 使用方法：
# sh merge_request.sh -s <SourceBranch> -t <Title> -c <comment>
# 样例：
# sh merge_request.sh -s feature_zhangsan_20200701_xxx -t "增加修改用户名流程" -c "1.增加修改用户名流程"
# 备注：
# 1.需要手动在脚本设置自己在gitlab的名字
# 2.需要手动在脚本设置自己在gitlab的token
# 3.需要手动在脚本设置项目在gitlab的ID"
# 4.默认merge到master分支

RED_COLOR='\033[31m'
GREEN_COLOR='\033[32m'
YELLOW_COLOR='\033[33m'
BLUE_COLOR='\033[34m'
END_COLOR='\033[0m'

function print_red
{
    echo -e "${RED_COLOR}$*${END_COLOR}"
}
function print_green
{
    echo -e "${GREEN_COLOR}$*${END_COLOR}"
}
function print_yellow
{
    echo -e "${YELLOW_COLOR}$*${END_COLOR}"
}
function print_blue
{
    echo -e "${BLUE_COLOR}$*${END_COLOR}"
}

function help
{
    print_yellow "使用方法："
    print_blue "\tsh merge_request.sh -s <SourceBranch> -t <Title> -c <comment>\r\n"
    print_yellow "样例："
    print_blue "\tsh merge_request.sh -s feature_zhangsan_20200701_xxx -t \"增加修改用户名流程\" -c \"1.增增加修改用户名流程\"\r\n"
    print_yellow "备注："
    print_blue "\t1.需要手动在脚本设置自己在gitlab的名字"
    print_blue "\t2.需要手动在脚本设置自己在gitlab的token"
    print_blue "\t3.需要手动在脚本设置项目在gitlab的ID"
    print_blue "\t4.默认merge到master分支"
}

if [ $# == 0 ]; then
    help
    exit
fi

# 以下三项需要开发自行手动配置
AssigneeName=""
PrivateToken=""
ProjectId=0

# 以下三项需要通过脚本参数传入
Source=""
Title=""
Comment=""

# 默认merge到master分支
Target="master"

while getopts "s:t:c:" opt; do
    case $opt in
    s)
        Source=$OPTARG
        ;;
    t)
        Title=$OPTARG
        ;;
    c)
        Comment=$OPTARG
        ;;
    *)
        echo "Invalid option: -$OPTARG" 
        ;;
    esac
done

if [ -z $Source ]; then
    print_red "please input source branch\r\n"
    exit
fi
if [ -z $Title ]; then
    print_red "please input title\r\n"
    exit
fi
if [ -z $Comment ]; then
    print_red "please input comment\r\n"
    exit
fi
if [ -z $AssigneeName ]; then
    print_red "please config AssigneeName in shell\r\n"
    exit
fi
if [ -z $PrivateToken ]; then
    print_red "please config PrivateToken in shell\r\n"
    exit
fi
if [ $ProjectId -eq 0 ]; then
    print_red "please config ProjectId in shell\r\n"
    exit
fi

Header="PRIVATE-TOKEN: ${PrivateToken}"

Data="source_branch=${Source}&target_branch=${Target}&assignee_name=${AssigneeName}&title=${Title}&description=${Comment}"

Url="https://git.yoururl.com/api/v4/projects/${ProjectId}/merge_requests"

print_blue "提交人：\t[${AssigneeName}]"
print_blue "MergeTo：\t[${Source}] => [${Target}]"
print_blue "Title：\t\t[${Title}]"
print_blue "Comment：\t[${Comment}]\r\n"

exit
MergeRequestRes=`curl --header "${Header}" --data "${Data}" "${Url}" 2>/dev/null`

if [[ $MergeRequestRes == *"can_be_merged"* ]]; then
    print_green "MergeRequest提交成功!${END_COLOR}"
else
    print_red "MergeRequest提交失败!\r\n"
    print_yellow "可能是如下原因："
    print_yellow "\t1.脚本token配置错误"
    print_yellow "\t2.源分支名错误"
    print_yellow "\t3.源分支存在未关闭的merge request"
    print_yellow "\t4.脚本中的项目ID配置错误"
fi
