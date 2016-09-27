# To use this run: nix-shell selfcontained.nix
# Only requires a newish (15.03+) nixpkgs in the external env to boostrap.
{ bootpkgs ? import <nixpkgs> {}
# Defaultable channel url and sha256 args so that CI can inject. Avoid hardcoding!
# You can build the environment as a package with different pinned channels
# in your CI flows (let machines do this work) by passing in new values of
# the pinned channel url and sha256. Don't hardcode. You will hate yourself
# later.
, url ? "https://nixos.org/releases/nixos/16.09/nixos-16.09beta430.c4469ed/nixexprs.tar.xz"
, sha256 ? "1jwkjxg9k0n2x6assgcbl1dgi3g1gjk07zdpanxyswiyrdlggs39"
, ... }:
let

  # Create specified nixpkgs channel and place in nix store
  pkgszip = bootpkgs.fetchzip { inherit url sha256; };
  # Import the expression into pkgs binding
  pkgs = import pkgszip {};

  # Now we can inherit attrs from pkgs (the pinned channel).
  # There should be no more references to bootpkgs now.
  inherit (pkgs) stdenv;

  rootDir = builtins.toPath ./.;
in stdenv.mkDerivation {
  name = "sinatra-on-nix";
  buildInputs = with pkgs; [
    ruby
    redis
    bundler
    foreman
    siege
  ];

  shellHook = ''
    ruby --version
    redis-cli --version
    bundle version
    siege --version 2>&1 | head -1

    mkdir -p ${toString rootDir}/var/{data,log,run}
  '';
}
