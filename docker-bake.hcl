variable "OWNER" {
  default = "visualon"
}
variable "FILE" {
  default = "nginx"
}
variable "TAG" {
  default = "latest"
}
variable "VERSION" {
  default = "stable"
}

group "default" {
  targets = ["build_base_ghcr", "build_ghcr", "build_docker"]
}

group "build" {
  targets = ["build_base_ghcr", "build_ghcr", "build_docker", "push_ghcr"]
}

group "push" {
  targets = ["push_ghcr"]
}

group "test" {
  targets = ["build_docker"]
}


target "base" {
  dockerfile = "base.Dockerfile"

  args = {
    ENABLED_MODULES = "brotli subs-filter"
    NGINX_FROM_IMAGE = "public.ecr.aws/nginx/nginx:${VERSION}-alpine"
  }

  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-base",
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-base-${TAG}",
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-base-${VERSION}",
  ]
}


target "build_base_ghcr" {
  inherits = ["base"]
  output   = ["type=registry"]
  tags     = [
    "ghcr.io/${OWNER}/cache:${FILE}-base-${TAG}",
    notequal("", VERSION) ? "ghcr.io/${OWNER}/cache:${FILE}-base-${VERSION}" : "",
  ]
  cache-to = ["type=inline,mode=max"]
}

target "settings" {
  contexts = {
    nginx = "target:base"
  }

  target = "final"

  arg = {
    VERSION = "${VERSION}"
  }

  cache-from = [
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}",
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-${TAG}",
    "type=registry,ref=ghcr.io/${OWNER}/cache:${FILE}-${VERSION}",
  ]
}

target "build_ghcr" {
  inherits = ["settings"]
  output   = ["type=registry"]
  tags     = [
    "ghcr.io/${OWNER}/cache:${FILE}-${TAG}",
    notequal("", VERSION) ? "ghcr.io/${OWNER}/cache:${FILE}-${VERSION}" : "",
  ]
  cache-to = ["type=inline,mode=max"]
}

target "build_docker" {
  inherits = ["settings"]
  output   = ["type=docker"]
  tags     = [
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
    notequal("", VERSION) ? "ghcr.io/${OWNER}/${FILE}:${VERSION}" : "",
  ]
}

target "push_ghcr" {
  inherits = ["settings"]
  output   = ["type=registry"]
  tags     = [
    "ghcr.io/${OWNER}/${FILE}:${TAG}",
    notequal("", VERSION) ? "ghcr.io/${OWNER}/${FILE}:${VERSION}" : "",
  ]

  annotations = [
    "index,manifest:org.opencontainers.image.licenses=MIT"
    "index,manifest:org.opencontainers.image.authors=VisualOn GmbH <code@visualon.de>",
    "index,manifest:org.opencontainers.image.source=https://github.com/nginx/nginx",
    "index,manifest:org.opencontainers.image.version=${VERSION}",
    "index,manifest:org.opencontainers.image.description=Alpine NGINX with additional modules and optimized settings",
  ]
}
