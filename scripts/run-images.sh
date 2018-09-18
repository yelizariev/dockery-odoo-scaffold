#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

source "${DIR}/../.env"

if [ "$1" = '--pull' ]; then
    docker pull "${FROM}:${ODOO_VERSION}"
fi

# Create a dommy folder in case enterrpise has nt been cloned previously
# Otherwise, docker build would fail (ONBUILD)
if [ ! -d "/vendor/odoo/ee" ]; then
	mkdir "${DIR}/../vendor/odoo/ee"
	touch "${DIR}/../vendor/odoo/ee/.gitkeep"
fi


docker-compose -f docker-compose.yml build odoo
docker-compose build odoo
