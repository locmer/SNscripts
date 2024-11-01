#!/bin/bash

CITY="Amsterdam"

# Fetch the weather data in JSON format
RESPONSE=$(curl -s "http://wttr.in/${CITY}?format=j1")

# Check if the response contains valid JSON data
if echo "$RESPONSE" | jq -e . > /dev/null 2>&1; then
    # Extract the current temperature from the JSON response
    TEMPERATURE=$(echo "$RESPONSE" | jq -r '.current_condition[0].temp_C')
    LOAD=$(echo "$RESPONSE" | jq -r '.current_condition[0].uvIndex')
    VECTOR=$(echo "$RESPONSE" | jq -r '.current_condition[0].windspeedKmph')
    HUMIDITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].humidity')
    PRESSURE=$(echo "$RESPONSE" | jq -r '.current_condition[0].pressure')
    CLOUDCOVER=$(echo "$RESPONSE" | jq -r '.current_condition[0].cloudcover')
    VISIBILITY=$(echo "$RESPONSE" | jq -r '.current_condition[0].visibility')
    WINDDIR=$(echo "$RESPONSE" | jq -r '.current_condition[0].winddirDegree')
#    echo "The current temperature in Amsterdam is ${TEMPERATURE}°C."
else
    echo "Failed to get the temperature data."
fi

current_epoch=$(date +%s%3N)
url="http://localhost:8097/api/mid/sa/metrics"
apikey="XXXXXYYYYYYYYYYYYYYYYYYYYYYY"

json_data='[{"metric_type": "rack_temperature", "node": "Rack1", "value": '"${TEMPERATURE}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "celcius", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_load_index", "node": "Rack1", "value": '"${LOAD}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "UvIndex", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_vector", "node": "Rack1", "value": '"${VECTOR}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } , "unit": "Windspeed Kmph", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_humidity", "node": "Rack1", "value": '"${HUMIDITY}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "hps", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_pressure", "node": "Rack1", "value": '"${PRESSURE}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "Pascal", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_cloudcover", "node": "Rack1", "value": '"${CLOUDCOVER}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "Cover %", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_visibility", "node": "Rack1", "value": '"${VISIBILITY}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "km", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"

json_data='[{"metric_type": "rack_winddir", "node": "Rack1", "value": '"${WINDDIR}"', "timestamp": '"${current_epoch}"', "ci2metric_id": { "node": "Rack1" } ,"unit": "dgr", "source": "EnvMonitor"}]'
curl -v "${url}" -H "Content-Type: application/json" -H "Accept: application/json" -H "Authorization: Key ${apikey}" -d "${json_data}"