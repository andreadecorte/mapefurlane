INSTALL spatial;
LOAD spatial;

.output table

SELECT id, kind, tags['name'], tags['place'] FROM ST_ReadOSM('cropped.osm.pbf') WHERE tags['name:fur'] IS NULL AND tags['name'] IS NOT NULL AND tags['place'] != '';
