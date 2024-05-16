.DEFAULT_GOAL := setup 

setup:
	bash scripts/setup.sh

run:
	bash scripts/start-server.sh

clean: 
	bash scripts/cleanup.sh

migration:
	bash scripts/create-migration.sh

migrate:
	bash scripts/perform-migration.sh

start-frontend:
	bash scripts/frontend.sh start

build-frontend:
	bash scripts/frontend.sh build
