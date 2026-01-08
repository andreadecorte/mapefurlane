#!/bin/bash -e

YESTERDAY=$(date +'%y%m%d' -d'yesterday')
original_filename="nord-est-${YESTERDAY}.osm.pbf"
full_url="https://download.geofabrik.de/europe/italy/${original_filename}"
echo "downloading ${full_url}"
# Fails if file not found
curl --output /dev/null --silent --head --fail "${full_url}"
echo $YESTERDAY > MAPDATE.txt
