#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

docker run --user=$(id -u $(whoami)) -v $(pwd)/vendor/odoo/cc/odoo:/opt/odoo/odoo "${FROM}:${ODOO_VERSION}" apply-patches