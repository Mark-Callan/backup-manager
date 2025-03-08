#!/usr/bin/env bash

VERSION="${VERSION:-v1.7.2}"
IMAGE="garethgeorge/backrest:${VERSION}"

mkdir -p /srv/restic-backrest/certs /srv/restic-backrest/data /srv/restic-backrest/cache /srv/restic-backrest/tmp
test -f /srv/restic-backrest/certs/fullchain.pem || cp /etc/letsencrypt/live/srvr.farm/fullchain.pem /srv/restic-backrest/certs/
test -f /srv/restic-backrest/certs/privkey.pem || cp /etc/letsencrypt/live/srvr.farm/privkey.pem /srv/restic-backrest/certs/

docker network create -d bridge restic-backrest-net


docker pull ${IMAGE}
docker container rm -f restic-backrest-net 2>/dev/null || true;
docker run --rm \
	--net restic-backrest-net \
	--name restic-backrest \
	-p 10.0.0.64:9898:9898 \
	-p 10.0.0.64:9880:80 \
	-e BACKREST_PORT="0.0.0.0:9898" \
	-e BACKREST_DATA=/data \
	-e XDG_CACHE_HOME=/cache \
	-e TMPDIR=/tmp \
	-e TZ=America/Los_Anageles \
	-v /srv/restic-backrest/data:/data \
	-v /data/backups/repos:/repos \
	-v /srv/restic-backrest/tmp:/tmp \
	-v /opt/restic-backrest/config:/config \
	-v /srv/restic-backrest/cache:/cache \
	-v /data:/userdata \
	 ${IMAGE} ;

