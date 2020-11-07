FROM opensuse/tumbleweed
WORKDIR /build-scripts
RUN zypper --non-interactive in make ncurses perl wget tar xz git flex bison bc gzip openssl-devel libelf-devel python3 libtool automake autoconf libncurses5 ncurses ncurses5-devel go gettext-tools glib2-devel libpixman-1-0-devel meson ninja texinfo bzip2 libselinux1 grub2 xorriso
CMD ["./build.sh"]