## Change FROM_IMAGE value only for customizing dockery-odoo framework
## For a quickstart, use ours.
ARG  FROM_IMAGE=xoelabs/dockery-odoo:{{DEFAULT_BRANCH}}
FROM ${FROM_IMAGE}

## If you have access to enterprise
# ENV ODOO_ENTERPRISE=true
ENV ODOO_ENTERPRISE=false

## Examples of extending your project with vendored modules
## NOTE: later *modules* override their previous namesake
# COPY  --chown=odoo:odoo vendor/it-projects/*   /opt/odoo/addons/010
# COPY  --chown=odoo:odoo vendor/xoe/*           /opt/odoo/addons/020
# COPY  --chown=odoo:odoo vendor/c2c/*           /opt/odoo/addons/030

## Example of extending your project with custom libraries
# USER root
# RUN pip install python-telegram-bot pandas numpy
# USER odoo