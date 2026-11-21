FROM ubuntu:22.04

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    curl jq libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Download the pre-built Evilginx v3 binary for Linux AMD64
# This bypasses the need for Go and Make entirely
RUN curl -L https://github.com/kgretzky/evilginx2/releases/download/v3.4.0/evilginx-linux-amd64.tar.gz -o evilginx.tar.gz \
    && tar -xzf evilginx.tar.gz \
    && rm evilginx.tar.gz \
    && mv evilginx /usr/local/bin/evilginx \
    && chmod +x /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]
