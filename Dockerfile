
FROM debian:bullseye AS base

# Create separate targets for each phase, this allows us to cache intermediate
# stages when using Google Cloud Build, and makes the final deployment stage
# small as it contains only what is needed.
FROM base AS devtools

RUN apt-get update && apt-get install -y htop \
    git \
    cmake \
    clang \
    libnghttp2-dev \
    libyaml-dev \
    libnuma-dev \
    libssl-dev \
    ninja-build

# Copy the source code to /v/source and compile it.
FROM devtools AS grpc
ARG ssh_prv_key
ARG ssh_pub_key

WORKDIR /v/libs
RUN git clone -b v1.43.0 https://github.com/grpc/grpc
WORKDIR /v/libs/grpc
RUN git submodule update --init
WORKDIR /v/libs/grpc/cmake/build
RUN cmake ../.. -DgRPC_INSTALL=ON  -DCMAKE_BUILD_TYPE=Release
RUN make && make install
