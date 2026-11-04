# Pinned nixpkgs (nixos-26.05). Bump rev and sha256 together.
import (builtins.fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/7dcdd87373d72e7a2173e4db02e20d3d7f495cfd.tar.gz";
  sha256 = "09f5ys7xly8gaip09yxpp1xawqm4dlzrjq0ib8x80y9wsdpnp2xl";
}) { }
