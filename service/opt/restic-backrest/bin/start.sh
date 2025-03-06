#!/usr/bin/env bash

VERSION="v1.7.2"

mkdir -p /srv/restic-backrest/certs
test -f /srv/restic-backrest/certs/fullchain.pem || cp /etc/letsencrypt/live/srvr.farm/fullchain.pem /srv/restic-backrest/certs/
test -f /srv/restic-backrest/certs/privkey.pem || cp /etc/letsencrypt/live/srvr.farm/privkey.pem /srv/restic-backrest/certs/

docker network create -d bridge restic-backrest-net

docker pull garethgeorge/backrest:${VERSION}
docker container rm -f restic-backrest-net 2>/dev/null || true;
docker run --rm \
	--net restic-backrest-net \
	--name restic-backrest \
	-p 10.0.0.64:9898:9898 \
	-e BACKREST_PORT=9898 \
	-e BACKREST_DATA=/data \
	-e XDG_CACHE_HOME=/cache \
	-v /data/backups/repos:/data \
	-v /data/backups/config:/.config/backrest \
	-v /data/backups/.cache:/cache \
	nginx:latest ;

