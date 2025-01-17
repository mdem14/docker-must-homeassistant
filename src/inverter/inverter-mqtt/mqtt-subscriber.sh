#!/bin/bash

MQTT_SERVER=`cat /app/mqtt.json | jq '.server' -r`
MQTT_PORT=`cat /app/mqtt.json | jq '.port' -r`
MQTT_TOPIC=`cat /app/mqtt.json | jq '.topic' -r`
MQTT_DEVICENAME=`cat /app/mqtt.json | jq '.devicename' -r`
MQTT_USERNAME=`cat /app/mqtt.json | jq '.username' -r`
MQTT_PASSWORD=`cat /app/mqtt.json | jq '.password' -r`

while read rawcmd;
do

    echo "Incoming request send: [$rawcmd] to inverter."
    dotnet /app/inverter.dll set $rawcmd;

done < <(mosquitto_sub -h $MQTT_SERVER -p $MQTT_PORT -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" -t "$MQTT_TOPIC/sensor/$MQTT_DEVICENAME" -q 1)