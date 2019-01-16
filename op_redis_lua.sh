#!/bin/bash

host=0.0.0.0
port=6800

redis_key_idx=$1
redis_value=$2

echo "redis_key_idx:" $redis_key_idx
echo "redis_value:" $redis_value

redis-cli -h $host -p $port --eval temp.lua "" , $redis_key_idx $redis_value
