#!/bin/bash -e

MAPDATE=$(cat MAPDATE.txt)
bbox="12.308317,45.576808,13.923307,46.654392"
original_filename="nord-est-${MAPDATE}.osm.pbf"
cropped_filename="cropped.osm.pbf"
coastline_filename="water-polygons-split-4326"
output_filename="friul.mbtiles"


echo "I will start from ${original_filename}"
ls -altr
curl -s -S -O "https://download.geofabrik.de/europe/italy/${original_filename}"
osmium extract --strategy complete_ways --bbox "${bbox}" --overwrite "${original_filename}" -o ${cropped_filename}

# Get coastline
curl -s -S -O https://osmdata.openstreetmap.de/download/${coastline_filename}.zip
unzip -j ${coastline_filename}.zip "${coastline_filename}/water_polygons.shp" "${coastline_filename}/water_polygons.shx" -d coastline/

tilemaker --input ${cropped_filename} --output ${output_filename} --process resources/process-openmaptiles-fur.lua --config resources/config-openmaptiles.json --bbox ${bbox}

# Clean up temporary stuff
rm ${original_filename} ${coastline_filename}.zip
ls -altr
if [ ! -f "$output_filename" ]
then
	echo "File not generated."
	exit 1
fi
echo "All good!"
