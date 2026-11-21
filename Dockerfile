FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    build-essential libssl-dev git wget pkg-config curl jq \
    python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install Go
RUN wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && \
    rm go1.21.5.linux-amd64.tar.gz

ENV PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

# Clone Evilginx
RUN git clone https://github.com/kgretzky/evilginx2.git /opt/evilginx
WORKDIR /opt/evilginx

# Build Evilginx
RUN make

EXPOSE 7000

CMD ["./evilginx"]
