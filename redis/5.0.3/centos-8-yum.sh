#!/bin/bash

#安装
yum install redis -y

mkdir /etc/redis/
mkdir /var/log/redis/

cp /etc/redis.conf /etc/redis/

cd /etc/redis/

cp redis.conf redis-slave.conf

#bind地址
bindStr=$1
echo $bindStr
sed -i 's/bind 127.0.0.1/bind '${bindStr}'/g' /etc/redis/redis*
#port
sed -i 's/port 6379/port 6380/g' /etc/redis/redis-slave.conf
sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis/redis*
#以独立进程启动
sed -i 's/daemonize no/daemonize yes/g' /etc/redis/redis*
sed -i 's/# cluster-enabled yes/cluster-enabled yes/g' /etc/redis/redis*
sed -i 's/# cluster-config-file nodes-6379.conf/cluster-config-file nodes-6379.conf/g' /etc/redis/redis.conf
sed -i 's/# cluster-config-file nodes-6379.conf/cluster-config-file nodes-6380.conf/g' /etc/redis/redis-slave.conf
sed -i 's/# cluster-node-timeout 15000/cluster-node-timeout 15000/g' /etc/redis/redis*
sed -i 's/appendonly no/appendonly yes/g' /etc/redis/redis*
sed -i 's/# requirepass foobared/requirepass Sobey123/g' /etc/redis/redis*

mkdir -p /opt/redis-cluster/redis0{1,2}

cd /opt/redis-cluster/redis01/
nohup redis-server /etc/redis/redis.conf &

cd /opt/redis-cluster/redis02/
nohup redis-server /etc/redis/redis-slave.conf &

echo 'redis-cli --cluster create 172.16.148.15:6379 172.16.148.15:6380 172.16.148.17:6379 172.16.148.17:6380 172.16.148.18:6379 172.16.148.18:6380 --cluster-replicas 1 -a Sobey123'