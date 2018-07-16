#!/bin/bash

# the default node number is 3
N=${1:-3}


# start hadoop master container
sudo docker rm -f hadoop-master &> /dev/null
echo "start hadoop-master container..."
sudo docker run -itd \
                --net=hadoop \
                -p 50070:50070 \
                -p 8088:8088 \
                -p 9000:9000 \
                -p 8030:8030 \
                -p 8031:8031 \
                -p 8032:8032 \
                -p 8033:8033 \
                -p 10020:10020 \
                --name hadoop-master \
                --hostname hadoop-master \
                arnauprat/hadoop:latest &> /dev/null


# start hadoop slave container
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f hadoop-slave$i &> /dev/null
	echo "start hadoop-slave$i container..."
	sudo docker run -itd \
	                --net=hadoop \
                  -p 8042:8042 \
	                --name hadoop-slave$i \
	                --hostname hadoop-slave$i \
	                arnauprat/hadoop:latest &> /dev/null
	i=$(( $i + 1 ))
done 

# get into hadoop master container
sudo docker exec -it hadoop-master bash
