FROM python:3.10-slim

WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y make dos2unix

COPY ../server server
COPY ../web web

RUN find . -type f -print0 | xargs -0 dos2unix

WORKDIR /usr/src/app/server
RUN chmod +x scripts/*.sh
RUN make setup

EXPOSE 5000
CMD scripts/start-server.sh --host=0.0.0.0 --port=5000

