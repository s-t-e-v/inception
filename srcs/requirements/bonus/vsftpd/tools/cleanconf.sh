#!/bin/sh
files=$(ls /etc/vsftpd/vsftpd_user_conf)
users=""
lines=$(cat /etc/vsftpd/login.txt)
nb=1
for line in $lines
do
   if [ $(($nb%2)) -ne 0  ];
   then
       users="$users $line"
   fi
nb=$(($nb+1))
done
for conf in $files
do
   found=0
   for user in $users
   do
       if [ $conf = $user ];
       then
           found="1"
       fi
   done
   if [ $found != "1" ];
   then
       rm -f vsftpd_user_conf/$conf
       echo "File $conf deleted"
   fi
done
