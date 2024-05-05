#!/bin/bash

echo "Installing required dependencies..."
pip3 install -r requirements.txt

echo "Performing needed migrations..."
python3 manage.py migrate

echo "Importing preset of data..."
sqlite3 db.sqlite3 <setup.sql

echo "Created admin user with username 'admin' and the password 'password'"

echo "You can now start the server by running 'make run'"
