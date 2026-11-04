{ pkgs ? import ./nix/pkgs.nix }:

let
  inherit (pkgs) lib;

  luaEnv = pkgs.lua.withPackages (ps: [ ps.luafilesystem ]);

  # Only what the generator needs; edits elsewhere in the repo won't trigger a rebuild.
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./staticGen.lua
      ./templates
      ./content
      ./assets
    ];
  };
in
rec {
  # Toolchain only, built first in the Dockerfile so it gets its own cached layer.
  deps = pkgs.symlinkJoin {
    name = "hicksca-dev-deps";
    paths = [ luaEnv pkgs.darkhttpd ];
  };

  site = pkgs.runCommand "hicksca-dev-site" { nativeBuildInputs = [ luaEnv ]; } ''
    cp -r ${src}/. .
    chmod -R u+w .
    lua staticGen.lua
    # staticGen.lua exits 0 even on failure, so check the output exists.
    if [ ! -f index.html ]; then
      echo "staticGen.lua did not produce index.html" >&2
      exit 1
    fi
    mkdir -p $out
    cp -r index.html assets $out/
  '';

  app = pkgs.runCommand "hicksca-dev-app" { } ''
    mkdir -p $out/bin
    ln -s ${pkgs.darkhttpd}/bin/darkhttpd $out/bin/darkhttpd
    ln -s ${site} $out/www
  '';
}
