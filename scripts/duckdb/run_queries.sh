#!/bin/bash -e
# Run queries and dump results to files

MAPDATE=$(cat MAPDATE.txt)
folder="./static/stats"
cropped_filename="cropped.osm.pbf"
filename_existing="${folder}/${MAPDATE}-existing.csv"
# we also write a copy on a fixed destination. We could also symlink
filename_existing_latest="${folder}/existing-latest.csv"
# formatted table
filename_missing_latest="${folder}/missing-latest.txt"

~/.duckdb/cli/latest/duckdb < ./scripts/duckdb/all_existing_name_fur.sql | tee "${filename_existing}" "${filename_existing_latest}"
~/.duckdb/cli/latest/duckdb < ./scripts/duckdb/missing_name_fur.sql | tee "${filename_missing_latest}"

# Check results
ls -al "${folder}"

# we don't need it anymore
rm ${cropped_filename}
