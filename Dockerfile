ARG  FROM_IMAGE
FROM ${FROM_IMAGE}

## Adapt from here...

## Example of extending your project with custom libraries
USER root

RUN pip install python-slugify

USER odoo

# ============================================================
# Forward enforce minimal naming scheme on secondary build
# ============================================================

ONBUILD USER root
ONBUILD RUN rm -rf "${PATCHES_DIR}"

ONBUILD ENV LAYER_SUFFIX="-8"
ONBUILD ENV ODOO_VENDOR="${ODOO_VENDOR} ${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}"
ONBUILD ENV ODOO_SRC="${ODOO_SRC} ${ODOO_BASEPATH}/src${LAYER_SUFFIX}"
ONBUILD COPY --chown=odoo:odoo  vendor                      "${ODOO_BASEPATH}/vendor${LAYER_SUFFIX}"
ONBUILD COPY --chown=odoo:odoo  src                         "${ODOO_BASEPATH}/src${LAYER_SUFFIX}"
ONBUILD COPY --chown=odoo:odoo  migration.yaml              "${ODOO_MIG}"
ONBUILD COPY --chown=odoo:odoo  migration.d/*               "${ODOO_MIG_DIR}/"
ONBUILD COPY --chown=odoo:odoo  cfg.d                       "${ODOO_RC}"
ONBUILD COPY --chown=odoo:odoo  patches.d                   "${PATCHES_DIR}"
ONBUILD RUN /patches ${ODOO_BASEPATH} || true

ONBUILD WORKDIR ${ODOO_BASEPATH}/src
# ============================================================
