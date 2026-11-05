# hicksca.dev site & setup

This repository contains a simple static site generator for hicksca.dev, built using Lua.

## Current Structure

```shell
.
├── .github/
│   └── workflows/
│       └── publish.yml
├── assets/
│   ├── css/
│   │   └── style.css
│   └── img/
│       └── (various image files)
├── content/
│   └── about.md
├── nix/
│   └── pkgs.nix
├── templates/
│   └── template.html
├── .dockerignore
├── .gitignore
├── default.nix
├── Dockerfile
├── license
├── publish.sh
├── README.md
├── shell.nix
└── staticGen.lua
```
(not all this needs to be push will clean this up mostly for ref at the moment)


## Getting Started
~nix related commands are optional you can manuall install lua and dependances~   
- lua (LuaRocks) 
  - luafilesystem
- html-tidy

1. Clone this repository.
2. Run `nix-shell` to set up the development environment and manage dependencies.
3. Generator script is `staticGen.lua`.

## Usage
 
1. Edit the content in `content/about.md`.
2. Modify the HTML template in `templates/template.html` if needed.
3. Run the generator:
   ```shell
   lua staticGen.lua
   ```
4. The generator will create an `index.html` file based on the content and template.

## Container

The site can also be built and served from a container with Nix as the base (`nixos/nix`).
- `nix/pkgs.nix` pins nixpkgs so builds are reproducible
- `default.nix` runs `staticGen.lua` as a Nix build and bundles the output with `darkhttpd`

1. Build the image:
   ```shell
   docker build -t hicksca.dev .
   ```
2. Run it:
   ```shell
   docker run --rm -t -p 8080:8080 hicksca.dev
   ```
3. Preview at http://localhost:8080 (Ctrl+C to stop).

Note: `template.html` sets `<base href="https://hicksca.dev/">` so css/images load from the live site when previewing locally.

## Publish

Site is hosted on [srht.site](https://srht.site/) and published with [hut](https://sr.ht/~xenrox/hut/).

1. One time setup, run `hut init` and paste a personal token with the `meta.sr.ht/PROFILE:RO` and `pages.sr.ht/PAGES:RW` grants.
2. Build and publish:
   ```shell
   ./publish.sh
   ```
   Or build `site.tar.gz` only without publishing:
   ```shell
   PUBLISH=0 ./publish.sh
   ```

`publish.sh` builds the image, pulls the generated site out of the container as `site.tar.gz`, checks it has an `index.html`, then runs `hut pages publish`. `DOMAIN` and `IMAGE` can be overridden the same way as `PUBLISH`.

## Pipeline

Pushing to `main` runs `.github/workflows/publish.yml` on GitHub Actions, which installs hut and runs `publish.sh`. It can also be started by hand from the Actions tab (Run workflow).

- Needs a repo secret `SRHT_TOKEN` (Settings > Secrets and variables > Actions) holding a sr.ht token with the `pages.sr.ht/PAGES:RW` grant
- Use a separate token from the local `hut init` one so either can be revoked on its own
- sr.ht tokens expire, if publishing starts failing on auth swap in a new token

## To-Do

- Set up Git hook to deploy to local test environment
- Implement basic automated testing/linting
- ~Wrap build + publish into a `publish.sh`~
- ~Publish on push to `main` with GitHub Actions~
  

(more stuff to come as I think about it ...)

[license ISC](./license)
