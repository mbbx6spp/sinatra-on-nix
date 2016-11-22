{ fetchzip ? (import <nixpkgs> {}).fetchzip
, ... }:
let
  pkgsPath = fetchzip (import ./version.nix);
  pkgs = import pkgsPath {};

  inherit (pkgs) stdenv;
  rootDir = builtins.toPath ./.;
in stdenv.mkDerivation {
  name = "sinatra-on-nix";
  buildInputs = with pkgs; [
    ruby
    redis
    bundler
    foreman
    wrk
  ];

  shellHook = with pkgs; ''
    ${ruby}/bin/ruby --version
    ${redis}/bin/redis-cli --version
    ${bundler}/bin/bundle version
    ${wrk}/bin/wrk --version 2>&1 | head -1

    mkdir -p ${toString rootDir}/var/{data,log,run}
  '';
}
