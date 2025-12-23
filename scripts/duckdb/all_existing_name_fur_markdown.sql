INSTALL spatial;
LOAD spatial;

.output markdown

SELECT id, COALESCE(tags['name:it'], tags['name']) AS 'name:it', tags['name:fur'] as 'name:fur', tags['loc_name:fur'] as 'loc_name:fur', tags['name:sl'] as 'name:sl', tags['name:de'] as 'name:de', tags['place'], kind FROM ST_ReadOSM('cropped.osm.pbf') WHERE tags['name:fur'] != '' AND tags['place'] != '';
