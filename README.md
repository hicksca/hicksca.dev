# hicksca.dev site & setup
 
This repository contains a simple static site generator for hicksca.dev, built using Lua.
 
## Current Structure
 
```shell
.
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
2. Build the image and pull the generated site out as a tarball:
```shell
   docker build -t hicksca.dev .
   docker run --rm --entrypoint tar hicksca.dev -C /app/www/ --mode=u+w -czf - . > site.tar.gz
```
3. Publish:
```shell
   hut pages publish -d hicksca.dev site.tar.gz
```
 
## To-Do
 
- Set up Git hook to deploy to local test environment
- Implement basic automated testing/linting
- Wrap build + publish into a `publish.sh`
  
(more stuff to come as I think about it ...)
 
[license ISC](./license)
