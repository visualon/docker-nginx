# used by buildx
FROM nginx AS final

LABEL maintainer="Michael Kriese <michael.kriese@visualon.de>"
LABEL name="nginx"
# get changelog from renovate
LABEL org.opencontainers.image.source="https://github.com/nginx/nginx" \
  org.opencontainers.image.licenses="MIT"

COPY ./conf.d/ /etc/nginx/

ARG VERSION=stable
LABEL org.opencontainers.image.version="${VERSION}"

# used by renovate to update
FROM nginx:1.28.0

