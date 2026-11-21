FROM golang:1.21-bookworm AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    git build-essential libssl-dev pkg-config curl jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone Evilginx v3 (stable)
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Build with limited memory to prevent Render crashes
ENV CGO_ENABLED=1
RUN make

# Final stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl jq libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/evilginx /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]
