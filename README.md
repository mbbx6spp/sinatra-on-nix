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

In another terminal you can run benchmark via `siege`:

```bash
$ ./bench
...
```

Note that all the following are installed:

* Ruby v2.3.1p112
* Redis v3.0.7
* Bundler v1.12.5
* Siege v4.0.1

Plus all of their transitive dependencies. Every time you run
`./devenv` with the pinned channel (peek inside the script `devenv`)
you will get the exact same binaries on your OS/Arch pair, every time.

This is the power of Nix.

So what else can we do? Oh, I am so glad you asked...

TODO:

* Docker image example
* AMI image example
* Virtualbox image example

