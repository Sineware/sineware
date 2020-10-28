FROM opensuse/leap:15.2
WORKDIR /build-scripts
RUN zypper --non-interactive in gcc make ncurses perl wget tar xz git flex bison bc gzip openssl-devel libelf-devel python3 libtool automake autoconf libncurses5 ncurses ncurses5-devel go grub2 xorriso
CMD ["./build.sh"]