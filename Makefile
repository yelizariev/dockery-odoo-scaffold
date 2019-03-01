# Init the repository
ifeq ($(OS),Windows_NT)
	ENV = $$(cat .env | grep -v "\#" | xargs -d "\r")
else
	ENV = $$(cat .env | grep -v "\#" | xargs)
endif

init: chmod-scripts
	hack/init_repo.py
	editor .env
	editor Dockerfile

create: pull-base build

pull-base: chmod-scripts
	env $(ENV) hack/pull_image.py

build: chmod-scripts
	env $(ENV) hack/build_images.py


no-cache-build: chmod-scripts
	env $(ENV) hack/build_images.py --nocache

patch: chmod-scripts
	env $(ENV) hack/apply_patches.py


faq:
	cat hack/faq.txt

chmod-scripts:
	chmod -R +x hack
