FROM python:3.12-slim AS setup

WORKDIR /usr/src/app
# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    make \
    dos2unix \
    libmagic1 \
    npm

RUN pip3 install pipenv

# Copy python and react code, avoid dos incompatibility
COPY ../server server
COPY ../web web

RUN find . -type f -print0 | xargs -0 dos2unix

# Run setup
WORKDIR /usr/src/app/server
RUN chmod +x scripts/*.sh
RUN make setup

FROM setup AS debug

ENV LOAD_TEST_DATA=true

EXPOSE 5000
CMD pipenv run flask --app main --debug run --host=0.0.0.0 --port=5000

FROM setup AS prod

RUN pipenv install gunicorn

EXPOSE 5000
CMD pipenv run gunicorn -w 4 -b 0.0.0.0:5000 'main:app'
