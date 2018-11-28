FROM ubuntu:18.04
MAINTAINER Earle F. Philhower, III version: 0.4

# Install dependencies
RUN apt-get update && \
    apt-get install -y gcc g++ make flex bison texinfo autogen mingw-w64 git libgmp3-dev libmpfr-dev libmpc-dev zlib1g-dev clang wget autoconf gcc-aarch64-linux-gnu g++-aarch64-linux-gnu zip

# RPI
RUN mkdir -p /opt && \
    git clone --depth 1 --single-branch https://github.com/earlephilhower/rpitools /opt/raspi && \
    cd /opt/raspi/arm-bcm2708 && \
    rm -rf arm-bcm2708-linux-gnueabi arm-bcm2708hardfp-linux-gnueabi/ gcc-linaro-arm-linux-gnueabihf-raspbian gcc-linaro-arm-linux-gnueabihf-raspbian-x64

# Get Mac crosscompile code
RUN mkdir -p /opt && \
    git clone https://github.com/earlephilhower/osxcross /opt/osxcross && \
    cd /opt/osxcross/tarballs && \
    wget https://github.com/phracker/MacOSX-SDKs/releases/download/10.13/MacOSX10.10.sdk.tar.xz && \
    xz -d MacOSX10.10.sdk.tar.xz && \
    bzip2 -1 MacOSX10.10.sdk.tar

# Build it
RUN cd /opt/osxcross && UNATTENDED=1 GCC_VERSION=7.3.0 ./build.sh && UNATTENDED=1 GCC_VERSION=7.3.0 ./build_gcc.sh && rm -rf build

# Add /opt/* to all default PATHs
ENV PATH="/opt/raspi/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/bin/:/opt/osxcross/target/bin:${PATH}"
