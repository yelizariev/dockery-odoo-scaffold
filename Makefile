# Init the repository
ifeq ($(OS),Windows_NT)
	ENV = $$(cat .env | grep -v "\#" | xargs -d "\r")
else
	ENV = $$(cat .env | grep -v "\#" | xargs)
endif

ifeq ($(OS),Windows_NT)
	DEFAULT_EDITOR = start /wait /min cmd /C "%windir%\system32\notepad.exe"
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		DEFAULT_EDITOR = editor -w
	endif
	ifeq ($(UNAME_S),Darwin)
		DEFAULT_EDITOR += open -e -W
	endif
endif

init: chmod-scripts
	hack/init_repo.py
	$(DEFAULT_EDITOR) .env
	$(DEFAULT_EDITOR) Dockerfile

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
