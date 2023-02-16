FROM ubuntu:18.04
MAINTAINER Earle F. Philhower, III version: 0.5

# Install dependencies
RUN apt-get update && \
    apt-get install -y gcc g++ make flex bison texinfo autogen mingw-w64 git \
                       libgmp3-dev libmpfr-dev libmpc-dev zlib1g-dev clang \
                       wget autoconf gcc-arm-linux-gnueabihf \
                       g++-arm-linux-gnueabihf libssl-dev libhidapi-dev \
                       gcc-aarch64-linux-gnu g++-aarch64-linux-gnu zip \
                       python-pip gcc-i686-linux-gnu g++-i686-linux-gnu \
                       libtool pkg-config libusb-1.0-0-dev && \
    pip install virtualenv

# Get a cmake that's not ancient
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz && \
    tar -zxvf cmake-3.20.2.tar.gz && \
    cd cmake-3.20.2 && \
    ./bootstrap --parallel=12 && \
    make -j12 && \
    make install

# Get Mac crosscompile code
RUN mkdir -p /opt && \
    git clone https://github.com/tpoechtrager/osxcross /opt/osxcross && \
    bash /opt/osxcross/tools/get_dependencies.sh && \
    cd /opt/osxcross/tarballs && \
    wget http://192.168.1.8/MacOSX10.11.sdk.tar.xz && \
    xz -d MacOSX10.11.sdk.tar.xz && \
    bzip2 -1 MacOSX10.11.sdk.tar

# Build it
RUN cd /opt/osxcross && UNATTENDED=1 GCC_VERSION=7.3.0 ./build.sh && UNATTENDED=1 GCC_VERSION=7.3.0 ./build_gcc.sh && rm -rf build

# Add /opt/* to all default PATHs
ENV PATH="/opt/osxcross/target/bin:${PATH}"
