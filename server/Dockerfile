FROM python:3.12-slim AS setup

WORKDIR /usr/src/app
# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    dos2unix \
    libmagic1

RUN pip3 install pipenv

# Copy python and react code, avoid dos incompatibility
COPY ../server server

RUN find . -type f -print0 | xargs -0 dos2unix

# Run setup
WORKDIR /usr/src/app/server
RUN chmod +x scripts/*.sh

RUN pipenv install --deploy --ignore-pipfile || exit 1
RUN pipenv install gunicorn


FROM setup AS prod

EXPOSE 5002
ENTRYPOINT ["scripts/entrypoint.sh"]
