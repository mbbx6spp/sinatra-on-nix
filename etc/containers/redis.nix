# First up we have named arguments for the lambda that defines the Docker
# image build itself.

# As before we request fetchzip so we can bootstrap from the
# pinned version of the nixpkgs channel we defined in the
# project root's channel.nix file (see further below).
{ fetchzip ? (import <nixpkgs> {}).fetchzip
# We can specify the name of the application that uses
# this container. We default to 'sinatra-on-nix'.
, app ? "sinatra-on-nix"
# We can override on the command-line when we build this
# Docker image the name of the image itself. Default: "redis"
, name ? "redis"
# We can override the port to expose for Redis via command-line.
# Default: 6379
, port ? 6379
# We can override the user and group names used to run the Redis
# process inside this container.
# Default: "redis" for both cases
, user ? "redis"
, group ? "redis"
}:
let
  # Bootstrap (same as in shell.nix just more inlined) to pinned
  # channel specified in the project root's channel.nix.
  pkgs = import (fetchzip (import ../../channel.nix)) {};

  # Bring into scope from the new pkgs namespace the named
  # values for convenience.
  inherit (pkgs) stdenv dockerTools redis runit;

  # Define path to the dataDir used for redis.
  dataDir = "/var/lib/${name}";

in dockerTools.buildImage {
  # Set the name of the Docker image
  name = "${app}-${name}";

  # script that sets up the container image before baking.
  runAsRoot = ''
    #!${stdenv.shell}
    ${dockerTools.shadowSetup}
    groupadd -r "${group}"
    useradd -r -g "${group}" -d "${dataDir}" -M "${user}"
    mkdir -p "${dataDir}"
    chown ${user}:${group} "${dataDir}"
  '';

  # Specifies all the Docker specific commands/directives you
  # might specify in a Docker file.
  config = {
    Cmd = [
      "${runit}/bin/chpst"
      "-u${user}:${group}"
      "-U${user}:${group}"
      "-P"
      "${redis}/bin/redis-server"
      "--protected-mode no"
    ];
    ExposedPorts = {
      "6379/tcp" = {};
    };
    WorkingDir = dataDir;
    Volumes = {
      "${dataDir}" = {};
    };
  };
}
