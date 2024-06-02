#!/bin/bash

/usr/bin/scanimage -L

# keep container for debug purposes awake
# while true; do
#     sleep 1
# done
echo "Starting brscand"

brscand -A 192.168.10.25 192.168.10.20