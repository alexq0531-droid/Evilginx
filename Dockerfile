FROM ubuntu:22.04

# Install basic dependencies
RUN apt-get update && apt-get install -y \
    build-essential libssl-dev git wget pkg-config curl jq \
    python3 python3-pip golang-go && \
    rm -rf /var/lib/apt/lists/*

# Clone Evilginx
RUN git clone https://github.com/kgretzky/evilginx2.git /opt/evilginx
WORKDIR /opt/evilginx

# Build Evilginx
# We use 'go get' first to ensure modules are ready, then make
RUN go mod download
RUN make

EXPOSE 7000

CMD ["./evilginx"]
