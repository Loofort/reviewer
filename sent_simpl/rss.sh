#!/bin/bash

while true; do
   ps aux | grep "python .*train" | grep -v grep | awk '{sum=sum+$6}; END {print sum/1024 " MB"}'
   sleep $1
done