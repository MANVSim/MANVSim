FROM python:3.12-slim

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y \
    make \
    dos2unix \
    libmagic1 \
    npm

RUN pip3 install pipenv

COPY ../server server
COPY ../web web

RUN find . -type f -print0 | xargs -0 dos2unix

WORKDIR /usr/src/app/server
RUN chmod +x scripts/*.sh
RUN make setup

ENV LOAD_TEST_DATA=true

EXPOSE 5000
CMD pipenv run flask --app main --debug run --host=0.0.0.0 --port=5000

