#!/bin/sh

set -eux pipefail

for db in ${1}; do
    /entrypoint-migrator.sh -f ./.marabunta.yml --database "${db}"
done
