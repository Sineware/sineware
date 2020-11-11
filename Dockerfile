FROM opensuse/tumbleweed
WORKDIR /build-scripts
RUN zypper --non-interactive in make perl wget tar xz git flex bison bc gzip python3 libtool automake autoconf go gettext-tools meson ninja texinfo bzip2 grub2 xorriso openssl-devel libelf-devel
CMD ["./build.sh"]