INSTALL spatial;
LOAD spatial;

COPY (SELECT id, tags['name:fur'] AS 'name:fur', tags['loc_name:fur'] AS 'loc_name:fur', COALESCE(tags['name:it'], tags['name']) AS 'name:it', tags['name:sl'] AS 'name:sl', tags['name:de'] AS 'name:de', tags['place'] AS place, kind FROM ST_ReadOSM('cropped.osm.pbf') WHERE tags['name:fur'] != '' AND tags['place'] != '' ORDER BY "name:fur" ASC) TO '/dev/stdout' WITH (FORMAT csv, HEADER);
