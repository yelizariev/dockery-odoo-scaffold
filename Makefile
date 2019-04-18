### Load some important stuff

include .env
ccred=$(if $(filter $(OS),Windows_NT),,$(shell    echo "\033[31m"))
ccgreen=$(if $(filter $(OS),Windows_NT),,$(shell  echo "\033[32m"))
ccyellow=$(if $(filter $(OS),Windows_NT),,$(shell echo "\033[33m"))
ccbold=$(if $(filter $(OS),Windows_NT),,$(shell   echo "\033[1m"))
cculine=$(if $(filter $(OS),Windows_NT),,$(shell  echo "\033[4m"))
ccend=$(if $(filter $(OS),Windows_NT),,$(shell    echo "\033[0m"))

sleep := $(if $(filter $(OS),Windows_NT),timeout,sleep)

ifeq ($(OS),Windows_NT)
	# Docker for Windows takes care of the user mapping.
else
	ifndef COMPOSE_IMPERSONATION
		COMPOSE_IMPERSONATION="$(shell id -u):$(shell id -g)"
	endif
endif


### Common repo maintenance

create: pull build patch

patch: patch-docs
	docker-compose run apply-patches

update:
	git pull scaffold master



### docker-compose shortcuts, nothing exciting.

run:
	docker-compose up odoo

scaffold:
	docker-compose run scaffold

shell:
	docker-compose run shell

tests:
	docker-compose run tests

migrate:
	docker-compose run migrate



### Pulling images

pull: pull-base pull-devops

pull-base:
	docker pull $(FROM):$(ODOO_VERSION)-base

pull-devops:
	docker pull $(FROM):$(ODOO_VERSION)-devops



### Building images

build: build-base-docs build-base build-devops-docs build-devops

build-base:
	docker build --tag $(IMAGE):base-$(ODOO_VERSION) --build-arg "FROM_IMAGE=$(FROM):$(ODOO_VERSION)-base" .

build-devops:
	docker build --tag $(IMAGE):devops-$(ODOO_VERSION)  --build-arg "FROM_IMAGE=$(FROM):$(ODOO_VERSION)-devops" .

build-base-docs:
	@echo "$(ccyellow)$(ccbold)$(cculine)Build the production image. It contains:$(ccend)$(ccyellow)$(ccbold)"
	@echo "  - Odoo Community Code"
	@echo "  - Odoo Enterprise Code (if configured)"
	@echo "  - Other vendored modules (\`vendor\` folder)"
	@echo "  - Project modules (\`src\` folder)"
	@echo "  - Customizations from the Dockerfile$(ccend)"
	@echo "$(ccyellow)Note1: dockery-odoo patches are applied and baked into the image.$(ccend)"
	@echo "$(ccyellow)Note2: running this again, docker's build cache might kick in.$(ccend)"

build-devops-docs:
	@echo "$(ccyellow)$(ccbold)$(cculine)Build the devops image as sibling to the production image.$(ccend)$(ccyellow)$(ccbold)"
	@echo "  - WDB for comfortable debugging."
	@echo "  - XOE's dodoo suite of DevOps extensions."
	@echo "  - Headless browser for JS tests."
	@echo "  - Some advanced module templates."
	@echo "  - For details, visit: https://git.io/fjOtu$(ccend)"
	@echo "$(ccyellow)Note1: dockery-odoo patches are applied and baked into the image$(ccend)"
	@echo "$(ccyellow)Note2: running this again, docker's build cache might kick in.$(ccend)"



### Patching operations

patch-docs:
	@echo "$(ccyellow)$(ccbold)$(cculine)Apply patches to your current working directory.$(ccend)$(ccyellow)$(ccbold)"
	@echo "  - Patches are applied within the container context."
	@echo "  - Host volumes are bind-mounted in read-write mode."
	@echo "  - Therefore, changes reflect in your host's working directory."
	@echo "  - Pay attention to the $(ccgreen)green texts$(ccyellow) to see which patch is applied where."
	@echo "  - $(ccred)Failures$(ccyellow) indicate patches are already applied. No worries!$(ccend)"


### General info


info:
	@echo ""
	@echo "$(ccyellow)$(ccbold)$(cculine)Info about dockery-odoo.$(ccend)$(ccyellow)$(ccbold)"
	@echo ""
	@sleep 3
	@echo "  ▸ Shout it out loud: $(ccgreen)dockery-odoo is extremely cool!$(ccyellow)"
	@sleep 3
	@echo "  ▸ Look arround you. Did anybody hear your joyful outburst? 🤩"
	@echo ""
	@sleep 3
	@echo "In medias res ..."
	@echo ""
	@sleep 3
	@echo "  Shortly, we run $(ccend)$(ccyellow)make create$(ccbold). Sit back, relax and $(ccgreen)watch carefully.$(ccend)"
	@echo ""
	@echo ""
	@sleep 5
	make create
	@echo ""
	@echo ""
	@echo "$(ccbold)$(ccred)Whoow!$(ccyellow) Lots of stuff going on... "
	@echo ""
	@sleep 3
	@echo "Take your time. Go through the logs. And when you're ready..."
	@echo ""
	@sleep 5
	@echo "$(ccbold)$(ccyellow)$(cculine)Kick off odoo:$(ccend)"
	@echo ""
	@sleep 3
	@echo "   $(ccyellow)make run $(ccgreen)      ▸ your new homie"
	@echo ""
	@sleep 5
	@echo "$(ccbold)$(ccyellow)$(cculine)Other useful maintenance commands:$(ccend)"
	@echo ""
	@sleep 3
	@echo "   $(ccyellow)make create $(ccgreen)   ▸ rebuild your local environment"
	@sleep 3
	@echo "   $(ccyellow)make patch $(ccgreen)    ▸ patch your workdir"
	@sleep 3
	@echo "   $(ccyellow)make update $(ccgreen)   ▸ pull in scaffold changes"
	@echo ""
	@sleep 5
	@echo "$(ccbold)$(ccyellow)$(cculine)Other useful odoo commands:$(ccend)"
	@echo ""
	@echo "   $(ccyellow)make scaffold $(ccgreen) ▸ scaffold a module"
	@sleep 3
	@echo "   $(ccyellow)make shell $(ccgreen)    ▸ access an odoo shell"
	@sleep 3
	@echo "   $(ccyellow)make tests $(ccgreen)    ▸ run your tests"
	@sleep 3
	@echo "   $(ccyellow)make migrate $(ccgreen)  ▸ test your migration scripts"
	@echo ""
	@sleep 5
	@echo "$(ccbold)$(ccyellow)And there is more: have a look at ./Makefile and ./docker-compose.yml$(ccend)"
	@echo ""
	@echo "QED.    ▢"
	@echo ""
	@echo ""
