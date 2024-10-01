FROM node:20-slim AS build

WORKDIR /app

COPY ../web/package*.json ./
RUN npm ci

COPY ../web ./

ARG VITE_API_URL=https://localhost/web/

RUN npm run build


FROM nginx:1.27.1-alpine AS serve-prod
COPY --from=build /app/dist /usr/share/nginx/html
COPY ./web/nginx.conf /etc/nginx/conf.d/default.conf
