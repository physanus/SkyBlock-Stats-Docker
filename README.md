# SkyBlock Stats for Docker
A beautiful SkyBlock stats website for Docker 🌹 by https://sky.lea.moe/ @https://github.com/LeaPhant/skyblock-stats

## Genereal
This is some sort of a wrapper to automatically build the latest docker container for Lea's awesome sources.

## docker-compose.yml
To set up a working demo of this stats page, use a reverse proxy and create some ssl certificates.

```yaml
version: '3'
services:
  nginx:
    image: nginx
    container_name: nginx
    restart: always
    ports:
      - '80:80'
      - '443:443'
      - '3012:3012'
    volumes:
      - 'nginx-config:/etc/nginx/conf.d'
      - 'nginx-main-config:/etc/nginx'
      - 'nginx-certs:/etc/nginx/certs'
      - 'nginx-vhosts:/etc/nginx/vhost.d'
      - 'nginx-webroot:/usr/share/nginx/html'
      - 'nginx-well-known:/usr/share/nginx/html/.well-known'

  dockergen:
    image: jwilder/docker-gen
    container_name: nginx-docker-gen
    command: -notify-sighup nginx -watch /etc/docker-gen/templates/nginx.tmpl /etc/nginx/conf.d/default.conf
    volumes:
      - 'nginx-config:/etc/nginx/conf.d'
      - 'nginx-certs:/etc/nginx/certs'
      - 'nginx-vhosts:/etc/nginx/vhost.d'
      - 'nginx-webroot:/usr/share/nginx/html'
      - 'nginx-well-known:/usr/share/nginx/html/.well-known'
      - '/var/run/docker.sock:/tmp/docker.sock:ro'
      - './config/dockergen/nginx.tmpl:/etc/docker-gen/templates/nginx.tmpl'

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    container_name: letsencrypt
    environment:
      NGINX_DOCKER_GEN_CONTAINER: nginx-docker-gen
      NGINX_PROXY_CONTAINER: nginx
    volumes:
      - 'nginx-config:/etc/nginx/conf.d'
      - 'nginx-certs:/etc/nginx/certs'
      - 'nginx-vhosts:/etc/nginx/vhost.d'
      - 'nginx-webroot:/usr/share/nginx/html'
      - 'nginx-well-known:/usr/share/nginx/html/.well-known'
      - '/var/run/docker.sock:/var/run/docker.sock:ro'

  skyblock-stats:
    image: physanus/skyblock-stats:latest
    restart: always
    container_name: skyblock-stats
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
      - '/etc/localtime:/etc/localtime:ro'
      - '/etc/timezone:/etc/timezone:ro'
    environment:
      API_KEY: <create this on hypixel.net using /api ingame and paste here>
      VIRTUAL_HOST: skyblock.domain.tld
      LETSENCRYPT_HOST: skyblock.domain.tld
      LETSENCRYPT_EMAIL: <your email>

volumes:
  nginx-certs:
  nginx-config:
  nginx-main-config:
  nginx-vhosts:
  nginx-webroot:
  nginx-well-known:
    driver: local
```

Find the nginx.tmpl [here](https://github.com/jwilder/nginx-proxy/blob/master/nginx.tmpl).
