# docker-nginx

Alpine NGINX with more modules

## Build

```sh
> curl --retry 3 -fsSL -o base.Dockerfile https://raw.githubusercontent.com/nginx/docker-nginx/HEAD/modules/Dockerfile.alpine
> docker buildx bake
```
