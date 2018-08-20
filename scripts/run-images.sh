#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source "${DIR}/../.env"

if [ "$1" = 'pull' ]; then
    docker pull "${FROM}:${ODOO_VERSION}"
fi
docker-compose -f docker-compose.yml build odoo
docker-compose build odoo
