# Init the repository
ifeq ($(OS),Windows_NT)
	ENV = $$(cat .env | grep -v "\#" | xargs -d "\r")
else
	ENV = $$(cat .env | grep -v "\#" | xargs)
endif

init: chmod-scripts
	hack/init-repo.sh
	editor .env
	editor Dockerfile

create: pull-base build

pull-base: chmod-scripts
	env $(ENV) hack/pull-image.sh

build: chmod-scripts
	env $(ENV) hack/build-images.sh


no-cache-build: chmod-scripts
	env $(ENV) hack/build-images.sh nocache

patch: chmod-scripts
	env $(ENV) hack/apply-patches.py


faq:
	cat hack/faq.txt

chmod-scripts:
	chmod -R +x hack
