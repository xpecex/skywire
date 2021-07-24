# Skywire
[![Sponsor](https://img.shields.io/badge/Sponsor-Umbler-blue)](https://www.umbler.com/br/seja-bem-vindo?a=9jv4d6vj)
![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/xpecex/skywire/latest)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/xpecex/skywire/latest)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/xpecex/skywire/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/xpecex/skywire)
![GitHub](https://img.shields.io/github/license/xpecex/skywire)
[![](https://api.travis-ci.com/xpecex/skywire.svg?branch=main)](https://travis-ci.com/github/xpecex/skywire)

### What is skywire image?

> Is a multi-architecture docker image containing the official [Skywire Node binary](https://github.com/skycoin/skywire).

### What is Skywire?

> **Skywire** => The new Decentralized Internet, a wireless mesh network that pays you for supporting it.
> Learn more: [https://www.skycoin.com/](https://www.skycoin.com/)


### Tags:
 - latest
 - 0.4.2
 - 0.4.1
 - 0.4.0

### How to use this image

```shell
docker run --restart always -p 8000:8000 -v <YOUR_CONFIG_DIR>:/opt/skywire --name=skywire xpecex/skywire:latest skywire-visor
````
*NOTE: replace **YOUR_CONFIG_DIR** with the path you prefer to save skywire configuration and data files*

### How to build a local image

```shell
$ git clone https://github.com/xpecex/skywire.git
$ cd skywire
$ chmod +x build.sh

# Building a multi-arch image requires buildx 
# see more here: https://www.docker.com/blog/getting-started-with-docker-for-arm-on-linux/
$ ./build.sh
````

NOTE: Replace variables in ```build.sh``` as per your needs

-------------
[![Donate with Ethereum](https://en.cryptobadges.io/badge/small/0xE32cACcB768a3E65e83B3AF39ca31f446C06432D)](https://en.cryptobadges.io/donate/0xE32cACcB768a3E65e83B3AF39ca31f446C06432D)
[![Donate with Bitcoin](https://en.cryptobadges.io/badge/small/1E7HYMUCf3DD7kcpkyY38tzUzT2F8w1Rg7)](https://en.cryptobadges.io/donate/1E7HYMUCf3DD7kcpkyY38tzUzT2F8w1Rg7)