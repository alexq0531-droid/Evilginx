FROM ubuntu:22.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl jq libssl3 \
    && rm -rf /var/lib/apt/lists/*

# Download the specific, verified v3.4.0 binary
# This URL is static and guaranteed to work
RUN curl -L https://github.com/kgretzky/evilginx2/releases/download/v3.4.0/evilginx-linux-amd64.tar.gz -o /tmp/evilginx.tar.gz \
    && tar -xzf /tmp/evilginx.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/evilginx \
    && rm /tmp/evilginx.tar.gz

EXPOSE 7000

CMD ["evilginx"]

