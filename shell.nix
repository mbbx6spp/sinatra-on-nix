{ pkgs ? import <nixpkgs> {}
, ... }:
let

  inherit (pkgs) stdenv ruby redis bundler foreman siege;

  rootDir = builtins.toPath ./.;

in
stdenv.mkDerivation {
  name = "sinatra-on-nix";
  buildInputs = [
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

    mkdir -p ${toString rootDir}/var/{data,log,run}
  '';
}
