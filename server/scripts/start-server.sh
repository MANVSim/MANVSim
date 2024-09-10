#!/bin/bash

# Note this will fail from in a Windows environment due to resolving failures for .exe files. Use WSL context instead
if [ "$1" == "--sync" ]; then
  echo "Synching Pipfile..."
  pipenv sync
fi

flask --app main --debug run -p 5002
