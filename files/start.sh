#!/usr/bin/env bash

#cd skyblock-stats
echo "{\"hypixel_api_key\": \"$API_KEY\"}" > credentials.json

ls -la

npm start
cat /home/skyblock-stats/npm-debug.log

sleep 10000
