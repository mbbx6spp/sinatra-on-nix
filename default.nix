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

  gemConfig = {
    # If you needed ffi, add libffi to the inputs of the lambda
    # above and then uncomment the block below to build native
    # Ruby/C extensions.
    #ffi = spec: {
    #  buildInputs = [ libffi ];
    #  buildFlags = [
    #    "--with-cflags=-I${libffi}/include"
    #    "--with-ldflags=-L${libffi}/lib"
    #  ];
    #};

    # If you need nokogiri you would just need to include libxml2
    # and libxslt in the lambda inputs and uncomment the below.
    #nokogiri = spec: {
    #  buildInputs = [ libxslt libxml2 ];
    #  buildFlags = [
    #    "--with-xml2-config=${libxml2}/bin/xml2-config"
    #    "--with-xslt-config=${libxslt}/bin/xslt-config"
    #  ];
    #};

    # In fact we could swap out openssl for libressl if we preferred
    # and it would build using libressl. Whatever floats your boat.
    # The explicit expressiveness provided allows us to do far more
    # interesting things than in most FHS Linux distributions with
    # far greater ability to reason about how the software is built,
    # produced, and delivered.
    puma = spec: {
      buildInputs = [ openssl ];
      buildFlags = [
        "--with-cflags=-I${openssl}/include"
        "--with-ldflags=-L${openssl}/lib"
      ];
    };
  };
}
