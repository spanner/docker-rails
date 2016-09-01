#!/bin/bash -e

# Build and squash baseimage
docker build -t rails4-base ./base
ID=$(docker run -d rails4-base true)
docker export $ID | docker import - rails4-base-reimport

# Create onbuild image
docker build -t rails4-onbuild ./onbuild
