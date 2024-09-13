FROM python:3.12-slim AS setup

WORKDIR /usr/src/app

ARG VITE_API_URL=https://localhost:5002/web/

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    make \
    dos2unix \
    libmagic1 \
    npm

# Copy python and react code, avoid dos incompatibility
COPY ../web web

RUN find . -type f -print0 | xargs -0 dos2unix

# Run setup
WORKDIR /usr/src/app/web
RUN npm ci
RUN npm run build


FROM nginx:1.27.1-alpine AS serve-prod
EXPOSE 50003
COPY --from=setup /usr/src/app/web/dist /usr/share/nginx/html
COPY ./web/nginx.conf /etc/nginx/conf.d/default.conf
