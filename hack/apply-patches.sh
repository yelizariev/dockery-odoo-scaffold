#!/usr/bin/env bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

APPLY_DIR="${DIR}/../vendor/odoo/cc"
PATCHES=$(docker run --entrypoint "" "${FROM}:${ODOO_VERSION}-base"\
    cat patches
)
CORRECT_SHEBANG_BASH="#!/usr/bin/env bash"
eval "${PATCHES/\#\!\/bin\/bash/$CORRECT_SHEBANG_BASH}"

PREV_PWD=$(pwd)
cd "${DIR}/../vendor/odoo/cc/"
git stash push --keep-index --include-untracked --message "Patches for ${ODOO_VERSION}" &> /dev/null
git stash apply stash@{0} &> /dev/null
echo -e "${RED}Patches are in your submodule workdir (vendor/odoo/cc) and stashed there as: 'Patches for ${ODOO_VERSION}'${NC}"
cd ${PREV_PWD}
