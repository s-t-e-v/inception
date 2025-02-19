#!/bin/sh
if [ $# = "2" ]; then
    rm -f $2
    db_load -T -t hash -f $1 $2
    chmod 600 /etc/vsftpd/login.*
    echo "Base created"
    lines=$(cat $1)
    nb=1
    for line in $lines
    do
        if [ $(($nb%2)) -ne 0  ];
        then
            if [ ! -e vsftpd_user_conf/$line ];
            then
                touch /etc/vsftpd/vsftpd_user_conf/$line
                echo "file $line created"
            fi
        fi
        nb=$(($nb+1))
    done
else
    echo "Input and output files are needed"
fi
