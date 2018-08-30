#!/bin/sh

# Usage: ci-build-main.sh <SUFFIX>

set -eux

if [ $# -eq 0 ]; then
    image="${IMAGE}:${ODOO_VERSION}"
else
    image="${IMAGE}:${ODOO_VERSION}-${1}"
fi

from="${FROM}:${ODOO_VERSION}"

docker pull "${from}" &> /dev/null

docker build --tag "${image}" \
    --build-arg FROM_IMAGE="${from}" \
    .
docker push "${image}" &> /dev/null
