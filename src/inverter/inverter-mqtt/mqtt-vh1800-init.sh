#!/bin/bash
#
# Simple script to register the MQTT topics when the container starts for the first time...

MQTT_SERVER=`cat /app/mqtt.json | jq '.server' -r`
MQTT_PORT=`cat /app/mqtt.json | jq '.port' -r`
MQTT_TOPIC=`cat /app/mqtt.json | jq '.topic' -r`
MQTT_DEVICENAME=`cat /app/mqtt.json | jq '.devicename' -r`
MQTT_MANUFACTURER=`cat /app/mqtt.json | jq '.manufacturer' -r`
MQTT_MODEL=`cat /app/mqtt.json | jq '.model' -r`
MQTT_SERIAL=`cat /app/mqtt.json | jq '.serial' -r`
MQTT_VER=`cat /app/mqtt.json | jq '.ver' -r`
MQTT_USERNAME=`cat /app/mqtt.json | jq '.username' -r`
MQTT_PASSWORD=`cat /app/mqtt.json | jq '.password' -r`

registerTopic () {
    mosquitto_pub \
        -h $MQTT_SERVER \
        -p $MQTT_PORT \
        -u "$MQTT_USERNAME" \
        -P "$MQTT_PASSWORD" \
        -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" \
        -t ""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1/config" \
        -r \
        -m "{
            \"name\": \"$1_"$MQTT_DEVICENAME"\",
            \"uniq_id\": \""$MQTT_SERIAL"_$1\",
            \"device\": { \"ids\": \""$MQTT_SERIAL"\", \"mf\": \""$MQTT_MANUFACTURER"\", \"mdl\": \""$MQTT_MODEL"\", \"name\": \""$MQTT_DEVICENAME"\", \"sw\": \""$MQTT_VER"\"},
            \"state_topic\": \""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1\",
            \"state_class\": \"measurement\",
            \"unit_of_meas\": \"$2\",
            \"icon\": \"mdi:$3\"
        }"
}
registerEnergyTopic () {
    mosquitto_pub \
        -h $MQTT_SERVER \
        -p $MQTT_PORT \
        -u "$MQTT_USERNAME" \
        -P "$MQTT_PASSWORD" \
        -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" \
        -t "$MQTT_TOPIC/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1/LastReset" \
		-r \
        -m "1970-01-01T00:00:00+00:00"

    mosquitto_pub \
        -h $MQTT_SERVER \
        -p $MQTT_PORT \
        -u "$MQTT_USERNAME" \
        -P "$MQTT_PASSWORD" \
        -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" \
        -t ""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1/config" \
        -r \
        -m "{
            \"name\": \"$1_"$MQTT_DEVICENAME"\",
            \"uniq_id\": \""$MQTT_SERIAL"_$1\",
            \"device\": { \"ids\": \""$MQTT_SERIAL"\", \"mf\": \""$MQTT_MANUFACTURER"\", \"mdl\": \""$MQTT_MODEL"\", \"name\": \""$MQTT_DEVICENAME"\", \"sw\": \""$MQTT_VER"\"},
            \"state_topic\": \""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1\",
            \"last_reset_topic\": \""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/$1/LastReset\",			
            \"state_class\": \"measurement\",
            \"device_class\": \"$4\",
            \"unit_of_meas\": \"$2\",
            \"icon\": \"mdi:$3\"
        }"
}

registerInverterRawCMD () {
    mosquitto_pub \
        -h $MQTT_SERVER \
        -p $MQTT_PORT \
        -u "$MQTT_USERNAME" \
        -P "$MQTT_PASSWORD" \
        -i ""$MQTT_DEVICENAME"_"$MQTT_SERIAL"" \
        -t ""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/COMMANDS/config" \
        -r \
        -m "{
            \"name\": \""$MQTT_DEVICENAME"_COMMANDS\",
            \"uniq_id\": \""$MQTT_DEVICENAME"_"$MQTT_SERIAL"\",
            \"device\": { \"ids\": \""$MQTT_SERIAL"\", \"mf\": \""$MQTT_MANUFACTURER"\", \"mdl\": \""$MQTT_MODEL"\", \"name\": \""$MQTT_DEVICENAME"\", \"sw\": \""$MQTT_VER"\"},
            \"state_topic\": \""$MQTT_TOPIC"/sensor/"$MQTT_DEVICENAME"_"$MQTT_SERIAL"/COMMANDS\"
            }"
}

registerTopic   "WorkStateNo"                              ""                 "state-machine"               "none"  
registerTopic   "AcVoltageGrade"                           "Vac"              "current-ac"                  "voltage"
registerTopic   "RatedPower"                               "VA"               "lightbulb-outline"           "current"
registerTopic   "BatteryVoltage"                           "Vdc-batt"         "current-dc"                  "voltage"
registerTopic   "InverterVoltage"                          "Vac"              "current-ac"                  "voltage"
registerTopic   "GridVoltage"                              "Vac"              "current-ac"                  "voltage"
registerTopic   "BusVoltage"                               "Vdc/Vac"          "cog-transfer-outline"        "voltage"
registerTopic   "ControlCurrent"                           "Aac"              "current-ac"                  "current"
registerTopic   "InverterCurrent"                          "Aac"              "current-ac"                  "current"
registerTopic   "GridCurrent"                              "Aac"              "current-ac"                  "current"
registerTopic   "LoadCurrent"                              "Aac"              "current-ac"                  "current"
registerTopic   "PInverter"                                "W"                "cog-transfer-outline"        "power"
registerTopic   "PGrid"                                    "W"                "transmission-tower"          "power"
registerTopic   "PLoad"                                    "W"                "lightbulb-on-outline"        "power"
registerTopic   "LoadPercent"                              "%"                "progress-download"           "none"  
registerTopic   "SInverter"                                "VA"               "cog-transfer-outline"        "current"
registerTopic   "SGrid"                                    "VA"               "transmission-tower"          "current"
registerTopic   "SLoad"                                    "VA"               "lightbulb-on-outline"        "current"
registerTopic   "QInverter"                                "Var"              "cog-transfer-outline"        "current"
registerTopic   "QGrid"                                    "Var"              "transmission-tower"          "current"
registerTopic   "QLoad"                                    "Var"              "lightbulb-on-outline"        "current"
registerTopic   "InverterFrequency"                        "Hz"               "sine-wave"                   "none"
registerTopic   "GridFrequency"                            "Hz"               "sine-wave"                   "none"
registerTopic   "InverterMaxNumber"                        ""                 "format-list-numbered"        "none"
registerTopic   "CombineType"                              ""                 "format-list-bulleted-type"   "none"
registerTopic   "InverterNumber"                           ""                 "format-list-numbered"        "none"
registerTopic   "AcRadiatorTemp"                           "oC"               "thermometer"                 "temperature"
registerTopic   "TransformerTemp"                          "oC"               "thermometer"                 "temperature"
registerTopic   "DcRadiatorTemp"                           "oC"               "thermometer"                 "temperature"
registerTopic   "InverterRelayStateNo"                     ""                 "electric-switch"             "none"
registerTopic   "GridRelayStateNo"                         ""                 "electric-switch"             "none"
registerTopic   "LoadRelayStateNo"                         ""                 "electric-switch"             "none"
registerTopic   "NLineRelayStateNo"                        ""                 "electric-switch"             "none"
registerTopic   "DcRelayStateNo"                           ""                 "electric-switch"             "none"
registerTopic   "EarthRelayStateNo"                        ""                 "electric-switch"             "none"
registerTopic   "Error1"                                   ""                 "alert-circle-outline"        "none"
registerTopic   "Error2"                                   ""                 "alert-circle-outline"        "none"
registerTopic   "Error3"                                   ""                 "alert-circle-outline"        "none"
registerTopic   "Warning1"                                 ""                 "alert-outline"               "none"
registerTopic   "Warning2"                                 ""                 "alert-outline"               "none"
registerTopic   "BattPower"                                "W"                "car-battery"                 "power"
registerTopic   "BattCurrent"                              "Adc"              "current-dc"                  "current"
registerTopic   "BattVoltageGrade"                         "Vdc-batt"         "current-dc"                  "voltage"
registerTopic   "RatedPowerW"                              "W"                "certificate"                 "power"
registerTopic   "CommunicationProtocalEdition"             ""                 "barcode"                     "none"
registerTopic   "ArrowFlag"                                ""                 "state-machine"               "none"
registerTopic   "ChrWorkstateNo"                           ""                 "state-machine"               "none"
registerTopic   "MpptStateNo"                              ""                 "electric-switch"             "none"
registerTopic   "ChargingStateNo"                          ""                 "electric-switch"             "none"
registerTopic   "PvVoltage"                                "Vdc-pv"           "current-dc"                  "voltage"
registerTopic   "ChrBatteryVoltage"                        "Vdc-batt"         "current-dc"                  "voltage"
registerTopic   "ChargerCurrent"                           "Adc"              "current-dc"                  "current"
registerTopic   "ChargerPower"                             "W"                "car-turbopower"              "power"
registerTopic   "RadiatorTemp"                             "oC"               "thermometer"                 "temperature"
registerTopic   "ExternalTemp"                             "oC"               "thermometer"                 "temperature"
registerTopic   "BatteryRelayNo"                           ""                 "electric-switch"             "none"
registerTopic   "PvRelayNo"                                ""                 "electric-switch"             "none"
registerTopic   "ChrError1"                                ""                 "alert-circle-outline"        "none"
registerTopic   "ChrWarning1"                              ""                 "alert-outline"               "none"
registerTopic   "BattVolGrade"                             "Vdc-batt"         "current-dc"                  "voltage"
registerTopic   "RatedCurrent"                             "Adc"              "current-dc"                  "current"
registerTopic   "AccumulatedDay"                           "day"              "calendar-day"                "none"
registerTopic   "AccumulatedHour"                          "hour"             "clock-outline"               "none"
registerTopic   "AccumulatedMinute"                        "min"              "timer-outline"               "none"

# Register composite topics manually for now

registerTopic "BatteryPercent"                             "%"       "battery"                              "battery"

registerTopic "AccumulatedChargerPower"                    "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedDischargerPower"                 "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedBuyPower"                        "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedSellPower"                       "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedLoadPower"                       "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedSelfusePower"                    "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedPvsellPower"                     "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedGridChargerPower"                "KWH"     "chart-bell-curve-cumulative"          "energy"
registerTopic "AccumulatedPvPower"                         "KWH"     "chart-bell-curve-cumulative"          "energy"

# Register topic for push commands
registerInverterRawCMD
