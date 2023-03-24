# Une mape libare dute par furlan - An open map in Friulian language

* pe documentazion par furlan cjale [par culì](docs/informazions.md)

## What is it

A project for a dedicated [OpenStreetMap](https://www.openstreetmap.org) rendering in [Friulian](https://en.wikipedia.org/wiki/Friulian_language), a minority language from north-east of Italy.

## Why

The goal is to have the first digital map ever in this minority language. The goal is to cover Friuli region and the surrounding area.

## How

This rendering uses two tags:
* name:fur to represent the name of the feature in the official Friulian version
* loc_name:fur (optional) to represent the name of the feature in the local Friulian version (if different from the official one)

Those are rendered on the map with the second one in a smaller font, if it exists.

## Updates

The goal is to have regular updates Data updates are fully automated and they are triggered by a change in the [MAPDATE file](MAPDATE.txt). At merge, data will be generated and published.

## Technical stack

The whole generation process is automated through a GitHub Workflow available in this repository. The steps are described below.
1. getting extracts from geofabrik.de
2. cutting it with osmium
3. generating vector tiles with tilemaker
4. publishing vector tiles
5. publishing static files (visualization is done through MapLibre JS)

## Contributing

Any issue report or contribution is welcome!
