FROM ubuntu:16.04

# Install build tools
RUN apt-get update
RUN apt-get -y install git build-essential
RUN apt-get -y install curl wget

# Install cmake 3.14
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz && tar -xvf cmake-3.14.5.tar.gz
RUN cd cmake-3.14.5 && ./bootstrap && make -j4 && make install
RUN cmake --version

# Build Polkadot C++ API
COPY [".", "sr25519/"]
#RUN git clone https://github.com/usetech-llc/sr25519.git
RUN cd sr25519 && cmake . && make 