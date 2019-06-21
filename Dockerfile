ARG  FROM_IMAGE
FROM ${FROM_IMAGE}

## Adapt from here...

## Example of extending your project with custom libraries
USER root
# RUN pip install python-telegram-bot pandas numpy
USER odoo

# ============================================================
# Forward enforce minimal naming scheme on secondary build
# ============================================================

ONBUILD USER root
ONBUILD RUN rm -rf "${PATCHES_DIR}"
ONBUILD COPY --chown=odoo:odoo  vendor/*                    "${ODOO_VENDOR}/"
ONBUILD COPY --chown=odoo:odoo  src/*                       "${ODOO_SRC}/"
ONBUILD COPY --chown=odoo:odoo  migration.yaml              "${ODOO_MIG}"
ONBUILD COPY --chown=odoo:odoo  migration.d/*               "${ODOO_MIG_DIR}/"
ONBUILD COPY --chown=odoo:odoo  cfg.d                       "${ODOO_RC}"
ONBUILD COPY --chown=odoo:odoo  patches.d                   "${PATCHES_DIR}"
ONBUILD RUN /patches ${ODOO_BASEPATH} || true

# ============================================================
