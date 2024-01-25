FROM ubuntu:20.04
MAINTAINER Earle F. Philhower, III version: 0.7

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
                       gcc g++ make flex bison texinfo autogen mingw-w64 git \
                       libgmp3-dev libmpfr-dev libmpc-dev zlib1g-dev clang \
                       wget autoconf gcc-arm-linux-gnueabihf \
                       g++-arm-linux-gnueabihf libssl-dev libhidapi-dev \
                       gcc-aarch64-linux-gnu g++-aarch64-linux-gnu zip \
                       python3-pip gcc-i686-linux-gnu g++-i686-linux-gnu \
                       libtool pkg-config libusb-1.0-0-dev libtinfo6 sudo \
                       vim-nox cmake pbzip2 && \
    pip install virtualenv

# Add user and group 1000, all sudo
RUN addgroup --gid 1000 usergroup && adduser --uid 1000 --gid 1000 --system --no-create-home user && usermod -aG sudo user && echo "user ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/user-user

# Get a cmake that's not ancient
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz && \
    tar -zxvf cmake-3.20.2.tar.gz && \
    cd cmake-3.20.2 && \
    ./bootstrap --parallel=12 && \
    make -j12 && \
    make install && \
    rm -rf /tmp/cmake*

# Get Mac crosscompile code
RUN mkdir -p /opt && \
    git clone https://github.com/tpoechtrager/osxcross /opt/osxcross && \
    bash /opt/osxcross/tools/get_dependencies.sh && \
    cd /opt/osxcross/tarballs && \
    wget http://192.168.1.8/MacOSX11.3.sdk.tar.xz && \
    xz -d MacOSX11.3.sdk.tar.xz && \
    pbzip2 MacOSX11.3.sdk.tar

# Build it
RUN cd /opt/osxcross && \
    UNATTENDED=1 ./build.sh && \
    UNATTENDED=1 ./build_gcc.sh && \
    rm -rf build tarballs/*

# Add /opt/* to all default PATHs
ENV PATH="/opt/osxcross/target/bin:${PATH}"
