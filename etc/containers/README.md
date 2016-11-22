# Docker Images

We can build Docker images using Nix. The first example we have defined in
this project is the Redis container. Ok, sure, Redis is super simple but
let's take a walk through the lambda/Nix expression that defines what
Docker image to build.

Documentation is inline at [redis.nix](redis.nix).

## Building Docker Image

To build the Docker image:

```
# From project's etc/container working directory
$ nix-build ./redis.nix
...[redacted]...

# To override the app name named argument to lambda defining the Docker
# image build we would call with the following command-line:
$ nix-build ./redis.nix --argstr app myapp2
these derivations will be built:
  /nix/store/n5kp28zg51kgf0r7jc75406pmp4ldc2n-myapp2-redis-config.json.drv
  /nix/store/lr977cpa6yfx5ykl1yj2nfya9n5j9h67-docker-layer.drv
  /nix/store/gla29hmqy9q1zx2s9gwpyn153dn2a5lb-runtime-deps.drv
  /nix/store/xadxm8660m72sww3d48bfwjm5042cnak-myapp2-redis.tar.gz.drv
building path(s) ‘/nix/store/dxrpkm190zd1j64aq0gfirgsg331m7al-myapp2-redis-config.json’
building path(s) ‘/nix/store/6p33rcrrnmyxb8hjw4ckkr2wv4nw9vj1-docker-layer’
Formatting '/nix/store/6p33rcrrnmyxb8hjw4ckkr2wv4nw9vj1-docker-layer/disk-image.qcow2', fmt=qcow2 size=1073741824 encryption=off cluster_size=65536 lazy_refcounts=off refcount_bits=16
loading kernel modules...
mounting Nix store...
mounting host's temporary directory...
starting stage 2 (/nix/store/8yrpnppaf59xqya6ywx80m5mk2mrz1x8-vm-run-stage2)
mke2fs 1.42.13 (17-May-2015)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 25ebe95d-0bd0-4f66-a82f-36ed182b1513
Superblock backups stored on blocks:
	32768, 98304, 163840, 229376

Allocating group tables: 0/8   done
Writing inode tables: 0/8   done
Writing superblocks and filesystem accounting information: 0/8   done

/tmp/disk/layer /tmp/disk
/tmp/disk
/tmp/disk/layer /tmp/disk
/tmp/disk
Packing layer
[    1.168655] reboot: Power down
building path(s) ‘/nix/store/rspbp0jlz2wf6agi2g5k5fj1fz1x3hvl-runtime-deps’
building path(s) ‘/nix/store/jcw9n84bcnbsgiglmdzsjg775pf2jhh8-myapp2-redis.tar.gz’
Adding layer
Adding meta
Cooking the image
/nix/store/jcw9n84bcnbsgiglmdzsjg775pf2jhh8-myapp2-redis.tar.gz
```

You will then use the typical Docker dev cycle such as:

```
$ docker load < /nix/store/jcw9n84bcnbsgiglmdzsjg775pf2jhh8-myapp2-redis.tar.gz

$ docker run \
  --name myapp2-redis \
  --detach \
  --volume $PWD/var/data:/var/lib/myapp2-redis \
  --publish 127.0.0.1:6379:6379 \
  myapp2-redis
4cc49acb73f6e37a07351c660a50221d7bf2bca9fb89d346bf6119a64695d42b
```

Your redis data will now be written to your local development directory under
`./var/data`.


