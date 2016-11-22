# Sinatra on Nix

Example Sinatra project using Nix to configure it.

## Prerequisites

* Nix 1.11+

## Getting Started

```bash
$ cd path/to/this/clone
$ ./devenv
$ bundle install --path=.bundle
```

To start the Puma server running the `App` Sinatra web application
and `redis-server`:

```bash
$ env RACK_ENV=bench0 bundle exec foreman start
```

In another terminal you can run benchmark via `wrk`:

```bash
$ ./bench
...
```

Note that all the following are installed:

* Ruby v2.3.1p112
* Redis v3.0.7
* Bundler v1.12.5
* wrk (mystery meat 2012 version because Go projects just are this way?)

Plus all of their transitive dependencies. Every time you run
`./devenv` with the pinned channel (peek inside the script `devenv`)
you will get the exact same binaries on your OS/Arch pair, every time.

This is the power of Nix.

## Package Definition

See [Ruby Nix package definition (default.nix)](default.nix) for an example of how
we would specify a Nix expression for the distributable dependencies for
the application. We build the Puma Rubygems dependency with native Ruby/C
setup.

## Shell/Development Environment Definition

See [Development environment definition (shell.nix)](shell.nix) to see how we can
write a Nix expression to specify a fully bootstrappable (only requirement
is Nix tooling available in currently environment, nothing else) development
environment.

We could have started off this project with the command line approximation
of a dev environment for this project like so:

```bash
nix-shell -p ruby bundler bundix
```

This would have brought into scope the ruby tooling to get us started
without a Nix expression initially.

Then we would have proceeded as Ruby developers with common startup steps
for initializing a Ruby project like so:

```
$ echo "source 'https://rubygems.org'" > Gemfile
$ echo  >> Gemfile
$ echo "gem 'sinatra'"  >> Gemfile
# More dependencies
$ bundle package --path .bundle
# Generate gemsets.nix expression with dependencies included
$ bundix -d
```

Bundix is just a Nix expression encapsulating the dependencies defined in the
Gemfile* files maintained/generated in accordance with the `bundler` tooling.

More information on managing Ruby projects can be found here:
http://nixos.org/nixpkgs/manual/#sec-language-ruby

## What's Next?

So what else can we do? Oh, I am so glad you asked...

* Define Docker images using the same deterministic build/dependency
  management tooling Nix provides. See [README.md here](etc/containers).

TODO:

* AMI image example
* Virtualbox image example

