#!/bin/sh


# Usage: ci-build-helper.sh <SUFFIX>

set -eux

from="${IMAGE}:${ODOO_VERSION}"

docker build --tag "${IMAGE}:${1}" \
    --build-arg FROM_IMAGE="${from}" \
    "${FROMREPO}#master:images/${1}"
docker push "${IMAGE}:${1}" &> /dev/null
