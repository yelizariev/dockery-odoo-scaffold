#!/bin/sh

set -eux

for db in ${1}; do
    /entrypoint-migrator.sh -f ./.marabunta.yml --database "${db}"
done
