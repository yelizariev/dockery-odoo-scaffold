#!/bin/sh

# Usage: ci-build-main.sh <SUFFIX>

set -eux pipefail

image="${IMAGE}:${ODOO_VERSION}-${1}"

docker pull "${FROM}:${ODOO_VERSION}" &> /dev/null

docker build --tag "${image}" .
docker push "${image}" &> /dev/null
