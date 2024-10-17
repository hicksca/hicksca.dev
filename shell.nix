{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.lua
    pkgs.luaPackages.markdown
    pkgs.luaPackages.luafilesystem

    pkgs.html-tidy
  ];

  shellHook = ''
    export SHELL=$(which zsh)  # Use globally installed zsh
    if [ "$SHELL" = "$(which zsh)" ]; then
      echo "Using zsh inside nix-shell."
      exec zsh  # Explicitly start zsh and use global configs
    fi
  '';
}
