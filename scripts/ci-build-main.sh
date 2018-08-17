#!/bin/sh

# Usage: ci-build-main.sh <SUFFIX>

set -eux pipefail

if [ $# -eq 0 ]; then
    image="${IMAGE}:${ODOO_VERSION}"
else
    image="${IMAGE}:${ODOO_VERSION}-${1}"
fi

docker pull "${FROM}:${ODOO_VERSION}" &> /dev/null

docker build --tag "${image}" .
docker push "${image}" &> /dev/null
