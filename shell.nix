# To bootstrap to a specific version of nixpkgs (see version.nix)
# we need fetchzip lambda which has been part of nixpkgs for years.
# This means we can bootstrap with many old, current, and likely
# future versions of nixpkgs by only requiring fetchzip to bootstrap.
{ fetchzip ? (import <nixpkgs> {}).fetchzip
, ... }:
let
  # version.nix contains the URL and SHA256 for the version of the channel
  # we want to pin our environment to.
  # This ensures fully reproducible and truly deterministic environments
  # all the way through all transitive dependencies of this project.
  pkgsPath = fetchzip (import ./version.nix);
  # We import the contents of the pinned nixpkgs into the pkgs binding
  # so we can use below.
  pkgs = import pkgsPath {};

  inherit (pkgs) stdenv;
  # We get the project root dir as a path to use in the shellHook below.
  rootDir = builtins.toPath ./.;
in stdenv.mkDerivation {
  name = "sinatra-on-nix";
  # Define all the tools we need for the project here.
  buildInputs = with pkgs; [
    ruby
    bundix
    bundler
    foreman
    redis
    wrk
  ];

  # The shellHook just prints out the versions of the different tools we need
  # for this project and autocreates (if they don't exist) run-time/development
  # directories.
  shellHook = with pkgs; ''
    ${ruby}/bin/ruby --version
    ${redis}/bin/redis-cli --version
    ${bundler}/bin/bundle version
    ${wrk}/bin/wrk --version 2>&1 | head -1

    mkdir -p ${toString rootDir}/var/{data,log,run}
  '';
}
