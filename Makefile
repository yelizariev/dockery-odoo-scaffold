# Init the repository

ENV = $$(cat .env | grep -v "\#" | xargs)

init: chmod-scripts
	hack/init-repo.sh
	editor .env
	editor Dockerfile

create: pull build

build: chmod-scripts
	env $(ENV) hack/build-images.sh

pull:
    env $(ENV) docker pull "${FROM}:${ODOO_VERSION}"

chmod-scripts:
	chmod +x -R hack

