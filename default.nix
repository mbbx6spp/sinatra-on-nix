{ lib, bundlerEnv, stdenv, ruby, openssl }:
bundlerEnv {
  inherit ruby;

  name = "sinatra-on-nix-0.1";
  gemfile   = ./Gemfile;
  lockfile  = ./Gemfile.lock;
  gemset    = ./gemset.nix;
  meta = with lib; {
    description = "Sinatra on Nix example project.";
    homepage = https://github.com/mbbx6spp/sinatra-on-nix;
    license = licenses.bsd3;
    platforms = platforms.unix;
  };

  gemConfig = lib.recursiveUpdate defaultGemConfig {
    # Nixpkgs defines some default inputs for popular Ruby gems,
    # including puma, nokogiri, ffi, and others.
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
    # These are provided as defaultGemConfig. In order to
    # supplement our own overrides or additions without dropping
    # defaults.

    # If you needed curb, add libcurl to the inputs of the lambda
    # above and then uncomment the block below to build native
    # Ruby/C extensions.
    #curb = spec: {
    #  buildInputs = [ libcurl ];
    #};

    # In fact we could swap out openssl for libressl if we preferred
    # and it would build using libressl. Whatever floats your boat.
    # The explicit expressiveness provided allows us to do far more
    # interesting things than in most FHS Linux distributions with
    # far greater ability to reason about how the software is built,
    # produced, and delivered.
    # puma = spec: {
    #  buildInputs = [ libressl ];
    #  buildFlags = [
    #    "--with-cflags=-I${libressl}/include"
    #    "--with-ldflags=-L${libressl}/lib"
    #  ];
    #};
  };
}
