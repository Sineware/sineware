FROM ubuntu:focal
WORKDIR /build-scripts
#RUN zypper --non-interactive in make perl wget tar xz git flex bison bc gzip python3 libtool automake autoconf go gettext-tools meson ninja texinfo bzip2 grub2 xorriso openssl-devel libelf-devel

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install  -y \
  build-essential \
  autoconf \
  git \
  libguestfs-tools \
  syslinux \
  syslinux-efi \
  syslinux-common \
  util-linux \
  gdisk \
  e2fsprogs \
  grub-common

CMD ["./build.sh"]