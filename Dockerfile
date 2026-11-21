FROM golang:1.20-bookworm AS builder

# Install Git and dependencies explicitly
RUN apt-get update && apt-get install -y \
    git build-essential libssl-dev pkg-config curl jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone Evilginx v3 (stable)
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Build with minimal flags to reduce errors
ENV CGO_ENABLED=1
RUN make

# Final stage: Minimal runtime
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl jq libssl3 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/evilginx /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]
