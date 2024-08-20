FROM debian:latest AS build-env

# Install requirements
RUN apt-get update && \
    apt-get install -y \
    curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3 sed && \
    apt-get clean

# Install flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"

RUN flutter doctor -v
RUN flutter channel master
RUN flutter upgrade

# Build web
COPY . /app/
WORKDIR /app/
RUN flutter build web



FROM nginx:1.21.1-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf