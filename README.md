# Docker Demo

This demo gives a brief introduction to networking with [Docker][docker]. Please see my [blog post][cc-blog] for details. The demo starts a Python-based web server to which you can post JSON documents stored in a MongoDB. A get retrieves all currently stored JSON documents and prints them as plain text.

The demo is controlled by a `Makefile`. Please have a look at this `Makefile` to see the different Docker commands used. Also have a look at the `Dockerfile`s used to build the Docker images in `mongodb/Dockerfile` and `webserver/Dockerfile`.

Have fun with lightweight virtual machines made simple with Docker and feel free to contact me for any questions or comments.

## Prerequisites

Docker builds upon [Linux Containers][lxc] (LXC) and thus only runs on Linux. In order to allow you to also play with Docker on non-Linux machines, there are two ways to run this demo, i.e., inside a [Vagrant Box][vagrant] or directly on Linux. Please see the respective subsections below. For both cases you need to install `make`.

### Vagrant Box

If you decide to run the demo inside a Vagrant box, please install Vagrant accordingly. The supplied Vagrantfile requires Vagrant version 1.4.0 or higher, because starting from that version Docker can be automatically installed. As provider, VirtualBox is assumed. Once Vagrant is installed, just run
> `vagrant up; vagrant ssh`
> `cd /vagrant`

in the root directory. Then follow the same instructions as for native Linux.

### Native Linux

If you decide to run the demo on a native Linux, please install Docker according to your distribution. There are How-Tos for many different distributions in the Docker [documentation][docker-install-doc].

## Running the Demo

### 1. Build Images

In the first step, two Docker images are build. First, starting from an Ubuntu base image, Python is added. From this Python image, a python script comprising a simple web server is added to build the web server images.
> `make build`

### 2. Starting containers

In the second step, the containers are started:
> `make run`

### 3. Running Demo

In order to run the demo, run
> `make demo`

First, three JSON documents specifying the birthdays of famous physicists are POSTed to three different IP addresses. These three IP addresses demonstrate the different networking modes described in the blog post. Further, the web server MongoDB container is automatically linked to the MongoDB container. After POSTing, a single GET query is send to retrieve the birthdays as `text/plain`. Please have a look at the demo target in the `Makefile`.

You can re-run the demo multiple times which leads to more and more documents stored.

#### Show Running Containers

If you want to see the number of running containers, run
> `docker ps`

### 4. Stopping containers

In order to stop all running containers, run
> `make stop`

and to clean up run
> `make clean`

[docker]: http://docker.io
[cc-blog]: https://blog.codecentric.de/en/2014/01/docker-networking-made-simple-3-ways-connect-lxc-containers/
[lxc]: http://linuxcontainers.org/
[vagrant]: http://www.vagrantup.com
[docker-install-doc]: http://docs.docker.io/en/latest/installation/

