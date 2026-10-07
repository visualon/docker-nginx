# used by buildx, do not pin!
FROM nginx AS final

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>"
LABEL name="nginx"
# get changelog from renovate
LABEL org.opencontainers.image.source="https://github.com/nginx/nginx" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.description="Alpine NGINX with additional modules and optimized settings"

COPY ./nginx/ /etc/nginx/

RUN set -ex; \
  mkdir -p /etc/nginx/site; \
  ln -sf /app /etc/nginx/html; \
  true

ARG VERSION=stable
LABEL org.opencontainers.image.version="${VERSION}"

STOPSIGNAL SIGQUIT
WORKDIR /app

# used by renovate to update
FROM nginx:1.30.5@sha256:9bf97bd7714f5e24c1ccd545ecb9eb5435cb6d109c97cebb15e7e455e0239edb

