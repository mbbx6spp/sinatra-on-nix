# To bootstrap to a specific version of nixpkgs (see version.nix)
# we need fetchzip lambda which has been part of nixpkgs for years.
# This means we can bootstrap with many old, current, and likely
# future versions of nixpkgs by only requiring fetchzip to bootstrap.
{ fetchzip ? (import <nixpkgs> {}).fetchzip
, version ? import ./VERSION
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

  inherit (pkgs) stdenv callPackage;
  # We get the project root dir as a path to use in the shellHook below.
  rootDir = builtins.toPath ./.;
  # Setup ruby/gems environment
  gemsEnv = callPackage ./default.nix {};

in stdenv.mkDerivation {

  # name of project
  name = "sinatra-on-nix";

  # Set env to the Ruby project's package definition in default.nix
  # This allows us to distribute our application for deployment and
  # development purposes.
  env = gemsEnv;

  # Define all the tools we need for the project here.
  # These aren't just language/build requirements but runtime/infrastructure,
  # plus testing and benchmarking dependencies too.
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
