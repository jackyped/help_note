#!/bin/bash
############################

function help(){
    echo ' show ms-broadcast* list, list keys '
    echo ' show ms-broadcast-group, show the key '
    echo ' show ms-broadcast*     , show the keys '
}
funtion show(){
    local i=$1
    local key=$2
    local type=$3
    echo -e "## $i\t ## $key"
    if [ -z $type ]
    then
        showValue $key
    fi
}
function showValue(){
    local key=$1
    local cmdShowType=$exe' type '$key
    local type=`eval $cmdShowType`
    local cmdShow=''
    if [[ $type == "string" ]]
    then
        cmdShow=$exe' get '$key
    elif [[ $type == "set" ]]
    then
        cmdShow=$exe' smembers '$key 
    elif [[ $type == "zset" ]]
    then
        cmdShow=$exe' zrange '$key' 0 -1'
    elif [[ $type == "hash" ]]
    then
        cmdShow=$exe' hgetall '$key 
    else 
        echo 'What type ? '$type
    fi
    eval $cmdShow 
}

exe='./src/redis-cli -a ruaho123'
key=''
type=''
if [ ! -z $1 ]
then
    key=$1
    if [ ! -z $2 ]
    then
        type=$2
    fi
    
    cmd=$exe" keys "$key" | awk -OFS'\"'  '"'{print $1}'"'"
    echo $cmd 
    #eval $cmd 
    listKey=(`eval $cmd`)
    for ((i=0; i<${#listKey[@]); i++))
    do 
        item=${listKey[$i]}
        show $i $item $type
    done
else 
    help
fi




    
    
