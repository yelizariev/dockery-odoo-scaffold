ARG  FROM_IMAGE xoelabs/dockery-odoo:11.0
FROM ${FROM_IMAGE}

ENV ODOO_ENTERPRISE=false

# Load extra vendored modules
# COPY --chown=odoo:odoo 	vendor/xoe/...                /opt/odoo/addons/010
# COPY --chown=odoo:odoo 	vendor/it-projects-llc/...    /opt/odoo/addons/030

