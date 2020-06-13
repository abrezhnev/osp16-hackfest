#!/usr/bin/env bash

touch /root/vbmc-start.sh

for i in {0..4}
do
  vbmc add node-${i} --port 623${i} --address 192.168.10.1
  echo "vbmc start node-${i}" >> /root/vbmc-start.sh
done

chmod 755 /root/vbmc-start.sh
