FROM debian:latest AS setup-env

# Install requirements
RUN apt-get update && \
    apt-get install -y \
    curl git wget unzip libgconf-2-4 gdb libstdc++6 libglu1-mesa fonts-droid-fallback python3 sed android-sdk && \
    apt-get clean

# Install flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"

RUN flutter doctor -v && \
    flutter channel master && \
    flutter upgrade

# Build web
COPY ./app /app/
COPY ./config/app/config.json /app/assets/config/config.json
WORKDIR /app/


# Build and serve dev without android app
FROM setup-env AS build-dev
RUN flutter build web --base-href /webapp/
FROM nginx:1.27.1-alpine AS serve-dev
COPY --from=build-dev /app/build/web /usr/share/nginx/html
COPY ./app/nginx.conf /etc/nginx/conf.d/default.conf


FROM setup-env AS build-prod

# Install android SDK, tools and accepts licenses
RUN wget https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip -O commandlinetools.zip && \
    unzip commandlinetools.zip -d /usr/lib/android-sdk/cmdline-tools && \
    mv /usr/lib/android-sdk/cmdline-tools/cmdline-tools/ /usr/lib/android-sdk/cmdline-tools/latest
ENV ANDROID_SDK_ROOT="/usr/lib/android-sdk/"
ENV PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools"
RUN sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" && \
    yes y | sdkmanager --licenses

# Build app and web
RUN mkdir -p assets && \
    flutter build apk && \
    cp build/app/outputs/apk/release/app-release.apk assets/manvsim-app.apk && \
    flutter build web --base-href /webapp/


FROM nginx:1.27.1-alpine AS serve-prod
COPY --from=build-prod /app/build/web /usr/share/nginx/html
COPY ./app/nginx.conf /etc/nginx/conf.d/default.conf
