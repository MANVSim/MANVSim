.DEFAULT_GOAL := setup 

setup:
	pipenv run bash scripts/setup.sh

run:
	pipenv run bash scripts/start-server.sh

clean: 
	pipenv run bash scripts/cleanup.sh

migration:
	pipenv run bash scripts/create-migration.sh

migrate:
	pipenv run bash scripts/perform-migration.sh
