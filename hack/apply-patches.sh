#!/bin/bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

APPLY_DIR="${DIR}/../vendor/odoo/cc"
source <(docker run --entrypoint= "${FROM}:${ODOO_VERSION}" cat /patches)
PREV_PWD=$(pwd)
cd "${DIR}/../vendor/odoo/cc/"
git stash push --keep-index --include-untracked --message "Patches for ${ODOO_VERSION}"
echo -e "Patches stashed as: 'Patches for ${ODOO_VERSION}'"
cd ${PREV_PWD}
