#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd -P -- $(dirname -- $0) && pwd -P)

IMAGE=android-reversing-workbench
cd $SCRIPT_DIR/..

COMMIT_SHA=$(git rev-parse HEAD)
SOURCE_URL="${IMAGE}:${COMMIT_SHA}"

docker build \
    --build-arg SOURCE_URL=${SOURCE_URL} \
    --tag ${IMAGE}:${COMMIT_SHA} \
    --tag ${IMAGE}:latest \
    .
