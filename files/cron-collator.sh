#!/bin/bash

NUM=$(curl --fail --silent http://127.0.0.1:9615/metrics | grep -e best -e finalized | awk '{A[NR-1] = $2;} END { print A[0] - A[1] }')
NUM1=$(curl --fail --silent http://127.0.0.1:9616/metrics | grep -e best -e finalized | awk '{A[NR-1] = $2;} END { print A[0] - A[1] }')
INT=$(($NUM+$NUM1))

if [ $INT -gt 300 ]
then
echo restart
systemctl restart robonomics.service
else echo $INT
fi
