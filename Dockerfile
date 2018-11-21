FROM ubuntu:18.04
MAINTAINER Earle F. Philhower, III version: 0.1
RUN apt-get update && apt-get install -y gcc g++ make flex bison texinfo autogen mingw-w64 git libgmp3-dev libmpfr-dev libmpc-dev zlib1g-dev clang wget autoconf gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
RUN mkdir -p /opt && git clone https://github.com/earlephilhower/osxcross /opt/osxcross
RUN cd /opt/osxcross/tarballs && wget -nv https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/MacOSX10.10.sdk.tar.xz && xz -d MacOSX10.10.sdk.tar.xz && bzip2 -1 MacOSX10.10.sdk.tar
ENV UNATTENDED=1
ENV GCC_VERSION=7.3.0
RUN cd /opt/osxcross && ./build.sh && ./build_gcc.sh && rm -rf build
