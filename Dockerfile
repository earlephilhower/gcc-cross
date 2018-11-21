FROM ubuntu:18.04
MAINTAINER Earle F. Philhower, III version: 0.2

# Install dependencies
RUN apt-get update && apt-get install -y gcc g++ make flex bison texinfo autogen mingw-w64 git libgmp3-dev libmpfr-dev libmpc-dev zlib1g-dev clang wget autoconf gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Add /opt/osxcross/target/bin to all default PATHs
RUN echo -e "--- /etc/login.defs-orig	2018-11-21 19:11:16.170575405 +0000\n+++ /etc/login.defs	2018-11-21 19:12:07.582460197 +0000\n@@ -100,7 +100,7 @@\n #\n # (they are minimal, add the rest in the shell startup files)\n ENV_SUPATH	PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\n-ENV_PATH	PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games\n+ENV_PATH	PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/opt/osxcross/target/bin\n \n #\n # Terminal permissions\n" | patch -p1

# Get crosscompile code
RUN mkdir -p /opt && git clone https://github.com/earlephilhower/osxcross /opt/osxcross
RUN cd /opt/osxcross/tarballs && wget https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/MacOSX10.10.sdk.tar.xz && xz -d MacOSX10.10.sdk.tar.xz && bzip2 -1 MacOSX10.10.sdk.tar

# Build it
ENV UNATTENDED=1
ENV GCC_VERSION=7.3.0
RUN cd /opt/osxcross && ./build.sh && ./build_gcc.sh && rm -rf build

# Add to default PATH
RUN echo 'PATH=$PATH:/opt/osxcross/target/bin' >> /root/.bashrc
