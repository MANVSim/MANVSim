#!/bin/bash

pipenv run flask --app main db init
pipenv run flask --app main db upgrade
pipenv run python dbsetup.py
pipenv run gunicorn -w 1 --threads 32 -b 0.0.0.0:5002 --certfile=fullchain.pem --keyfile=privkey.pem 'main:app'
