#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

source "${DIR}/../.env"

if [ "$1" = '--pull' ]; then
    docker pull "${FROM}:${ODOO_VERSION}"
fi

# Create a dummy folder in case enterprise has nt been cloned previously
# Otherwise, docker build would fail (ONBUILD)
if [ ! -d "/vendor/odoo/ee" ]; then
	mkdir "${DIR}/../vendor/odoo/ee"
	touch "${DIR}/../vendor/odoo/ee/.gitkeep"
fi

echo -e "\n${RED}First we build the production image. It contains:${NC}\n"
echo -e "\t${GREEN}- Odoo Community Code${NC}\n"
echo -e "\t${GREEN}- Odoo Enterprise Code (if configured)${NC}\n"
echo -e "\t${GREEN}- Your customizations done in Dockerfile${NC}\n"
docker-compose -f docker-compose.yml build odoo

echo -e "\n${RED}Now we build the development image atop the production image.\n"
echo -e "\t${GREEN}- Complements the image with additional tools used during local development${NC}\n"
echo -e "\t${GREEN}- It uses a remote git context maintained by XOE.${NC}\n"
echo -e "\t${GREEN}- Therefore, as shared knowledge about dev images evolves, just rebuild with \`docker-compose build odoo\`.${NC}\n"
echo -e "\t${GREEN}- For details check: https://github.com/xoe-labs/dockery-odoo/blob/master/images/dev/Dockerfile${NC}\n"
docker-compose build odoo
