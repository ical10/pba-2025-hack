# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set up environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV RUST_LOG="error,evm=debug,sc_rpc_server=info,runtime::revive=debug"

# Install dependencies - with ARM-specific optimizations
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    curl \
    git \
    libclang-dev \
    libssl-dev \
    pkg-config \
    protobuf-compiler \
    lld \
    # Specific dependencies that may help ARM builds
    llvm \
    libudev-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Rust with specific ARM optimizations
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Add WebAssembly target
RUN rustup target add wasm32-unknown-unknown

# Create .cargo/config.toml with ARM-specific optimizations
RUN mkdir -p /root/.cargo
RUN echo '[target.aarch64-unknown-linux-gnu]' > /root/.cargo/config.toml && \
    echo 'rustflags = ["-C", "link-arg=-fuse-ld=lld"]' >> /root/.cargo/config.toml && \
    echo '[net]' >> /root/.cargo/config.toml && \
    echo 'git-fetch-with-cli = true' >> /root/.cargo/config.toml

# Create working directory
WORKDIR /polkadot-sdk

# Clone the repository (use shallow clone to speed up)
RUN git clone --depth 1 https://github.com/paritytech/polkadot-sdk .

# Build the substrate-node in release mode with specific flags for ARM
# Use fewer parallel jobs to avoid memory issues on ARM
RUN CARGO_NET_GIT_FETCH_WITH_CLI=true \
    RUST_BACKTRACE=1 \
    cargo build --release --bin substrate-node --jobs 2

# Expose the default p2p, RPC, and WebSocket ports
EXPOSE 30333 9933 9944

# Run the node in dev mode with external access enabled
CMD ["./target/release/substrate-node", "--dev", "--ws-external", "--rpc-external", "--rpc-cors=all"]
