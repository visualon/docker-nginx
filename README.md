# docker-nginx

![build](https://github.com/visualon/docker-nginx/actions/workflows/build.yml/badge.svg)
![License](https://img.shields.io/github/license/visualon/docker-nginx)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

Alpine NGINX with more modules

## Build

```sh
> curl --retry 3 -fsSL -o base.Dockerfile https://raw.githubusercontent.com/nginx/docker-nginx/HEAD/modules/Dockerfile.alpine
> docker buildx bake
```
