# syntax=docker/dockerfile:1
FROM nixos/nix:2.35.2

WORKDIR /build

# Realize the toolchain first so content edits don't re-fetch it.
COPY nix/ nix/
COPY default.nix .
RUN nix-build -A deps -o /deps

# Build the site and the runtime bundle.
COPY staticGen.lua .
COPY templates/ templates/
COPY content/ content/
COPY assets/ assets/
RUN nix-build -A app -o /app

USER 65534:65534
EXPOSE 8080

ENTRYPOINT ["/app/bin/darkhttpd", "/app/www", "--port", "8080", "--no-listing", "--header", "Cache-Control: no-store"]
