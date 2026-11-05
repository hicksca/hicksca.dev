#!/usr/bin/env bash
# Build the site in the Nix container and publish it to srht.site.
# Usage: ./publish.sh            build + publish
#        PUBLISH=0 ./publish.sh  build site.tar.gz only
set -euo pipefail

DOMAIN="${DOMAIN:-hicksca.dev}"
IMAGE="${IMAGE:-hicksca.dev}"
PUBLISH="${PUBLISH:-1}"

cd "$(dirname "$0")"

docker build -t "$IMAGE" .
docker run --rm --entrypoint tar "$IMAGE" -C /app/www/ --mode=u+w -czf - . > site.tar.gz

if ! tar -tzf site.tar.gz | grep -qx './index.html'; then
  echo "site.tar.gz has no index.html, not publishing" >&2
  exit 1
fi

if [ "$PUBLISH" = "1" ]; then
  hut pages publish -d "$DOMAIN" site.tar.gz
else
  echo "built site.tar.gz (PUBLISH=0, skipped publish)"
fi
