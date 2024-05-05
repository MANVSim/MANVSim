#!/bin/bash

echo "Installing required dependencies..."
pip3 install -r requirements.txt

echo "Performing needed migrations..."
python3 manage.py migrate

echo "Creating admin user..."
python3 manage.py createsuperuser --username admin --email admin@example.com --skip-checks

echo "Created admin user with username 'admin' and the specified password"

echo "You can now start the server by running 'make run'"
