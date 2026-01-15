INSTALL spatial;
LOAD spatial;

.mode duckbox
.maxrows 15000

SELECT id, tags['place'] AS place, tags['name'] AS name, kind FROM ST_ReadOSM('cropped.osm.pbf') WHERE tags['name:fur'] IS NULL AND tags['name'] IS NOT NULL AND tags['place'] != '' AND tags['place'] NOT IN ('square', 'farm') ORDER BY "name" ASC;
