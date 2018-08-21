#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Only for framework patches
APPLY_DIR="${DIR}/../vendor/odoo/cc"

# Load environment
source "${DIR}/../.env"

# Source the patches
source <(docker run ${IMAGE}:${ODOO_VERSION} patches)
