# Init the repository

ENV = $$(cat .env | grep -v "\#" | xargs)

init: chmod-scripts
	hack/init-repo.sh
	editor .env
	editor Dockerfile

create: pull-base build

build: chmod-scripts
	env $(ENV) hack/build-images.sh

pull-base:
    env $(ENV) docker pull "${FROM}:${ODOO_VERSION}"

patch: chmod-scripts
	env $(ENV) hack/apply-patches.sh

chmod-scripts:
	chmod +x -R hack

