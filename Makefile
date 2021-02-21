#!/usr/bin/make -f
include .env

PROJECT=forttest

main: deploy

run:
	docker-compose -p ${PROJECT} up --build --force-recreate -d

drop:
	docker-compose -p ${PROJECT} down

prune: drop
	docker container prune --force
	docker image prune --force

cli:
	docker-compose -p ${PROJECT} exec php-fpm sh

update:
	git fetch
	git pull origin `git rev-parse --abbrev-ref HEAD` || true

deploy: update run

st:
	docker-compose -p ${PROJECT} ps

####################################################
# ctags for vim
CTAGS_COMMON_EXCLUDES = \
	--exclude=*.vim \
	--exclude=temp \
	--exclude=log \
	--exclude=*.js \
	--exclude=doc

# ctags
ctags::
	rm -f TAGS
	ctags --recurse \
		--totals=yes \
		$(CTAGS_COMMON_EXCLUDES) \
		.

#.PHONY: linkgen
#linkgen:
#	@echo "\n Root URL ---> http://127.0.0.1:${PROJECT}/${PROJECT}"
