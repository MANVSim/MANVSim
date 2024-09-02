#!/bin/bash

echo "Installing dependencies from pipfile.."
pipenv install --deploy --ignore-pipfile

echo "Performing needed migrations..."
flask --app main db init 2>/dev/null
flask --app main db upgrade

echo "Insert default data into database..."
pipenv run python dbsetup.py

# echo "Created admin user with username 'admin' and the password 'password'"

echo "Building the frontend..."
(cd ../web/ &&
npm i &&
npm run build) || echo "Frontend build failed!" >&2

echo "You can now start the server by running 'make run'"
