#!/bin/bash

echo "Installing required dependencies..."
pip3 install -r requirements.txt

echo "Performing needed migrations..."
flask --app main db init 2>/dev/null
flask --app main db upgrade

# TODO: actually import preset of data
# echo "Importing preset of data..."
# sqlite3 db.sqlite3 <setup.sql

# echo "Created admin user with username 'admin' and the password 'password'"

echo "You can now start the server by running 'make run'"
