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
├── license
├── README.md
├── shell.nix
├── staticGen.lua
└── template.html
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

## To-Do

- Set up Git hook to deploy to local test environment
- Implement basic automated testing/linting
  

(more stuff to come as I think about it ...)

[license ISC](./license)
