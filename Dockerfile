FROM golang:1.21-bookworm AS builder

# Install dependencies for building
RUN apt-get update && apt-get install -y \
    git build-essential libssl-dev pkg-config curl jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone Evilginx v3 (stable)
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Build Evilginx
ENV CGO_ENABLED=1
RUN make

# Final stage: Minimal runtime
FROM ubuntu:22.04

# FIX: Use libssl3 instead of libssl1.1 which doesn't exist in Jammy
RUN apt-get update && apt-get install -y \
    curl jq libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from the builder stage
COPY --from=builder /app/evilginx /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]
