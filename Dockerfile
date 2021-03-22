FROM linuxserver/code-server:amd64-latest

RUN mkdir -p /opt/theos

RUN apt-get update && apt-get install -y \
    curl \
    fakeroot \
    git \
    perl \
    clang-6.0 \
    build-essential \
    unzip \
    rsync \
    subversion \
    lsb-release \
    wget \
    libtinfo5 \
    software-properties-common \
 && rm -rf /var/lib/apt/lists/* \
 && update-alternatives --set fakeroot /usr/bin/fakeroot-tcp

ENV THEOS /opt/theos
RUN git clone --recursive https://github.com/theos/theos.git $THEOS

RUN curl -LO https://github.com/sbingner/llvm-project/releases/download/v10.0.0-1/linux-ios-arm64e-clang-toolchain.tar.lzma
RUN TMP=$(mktemp -d) \
    && tar --lzma -xvf linux-ios-arm64e-clang-toolchain.tar.lzma -C $TMP \
    && mkdir -p $THEOS/toolchain/linux/iphone \
    && mv $TMP/ios-arm64e-clang-toolchain/* $THEOS/toolchain/linux/iphone/ \
    && rm -r $TMP linux-ios-arm64e-clang-toolchain.tar.lzma

RUN rm -rf $THEOS/sdks/* \
    && rm -rf $THEOS/sdks/ \
    && git clone https://github.com/xybp888/iOS-SDKs $THEOS/sdks/
