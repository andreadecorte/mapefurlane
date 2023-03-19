#!/bin/bash

MAPDATE=$(cat MAPDATE.txt)
bbox="12.308317,45.576808,13.923307,46.654392"
original_filename="nord-est-${MAPDATE}.osm.pbf"

echo "I will start from {original_filename}"
ls -altr
curl -O "https://download.geofabrik.de/europe/italy/{original_filename}"
osmium extract --strategy complete_ways --bbox ${bbox} --overwrite "{original_filename}" -o cropped.osm.pbf

tilemaker --input cropped.osm.pbf --output friul.mbtiles --process resources/process-openmaptiles-fur.lua --config resources/config-openmaptiles.json --bbox ${bbox}

ls -altr
# Clean up
rm ${original_filename} cropped.osm.pbf
ls -altr
echo "All good!"
