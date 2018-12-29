#!/bin/bash

conn="mysql -A -uUSER -pPWD --default-character-set=utf8 -hHOST -PPORT"

ids=$(cat rid.txt)
for id in $(echo "$ids")
do
    # read db
    sql="select * from test.t where c1='$id';"
    echo "$sql"| $conn -N>>a.txt

    # read redis
    echo "get pre#$id" | redis-cli -h HOST -p PORT >>b.txt
done

