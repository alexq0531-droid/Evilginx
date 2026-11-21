FROM golang:1.21-bookworm AS builder

# Install system dependencies required for compilation
RUN apt-get update && apt-get install -y \
    git build-essential libssl-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone Evilginx v3 (stable)
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Build
RUN make

# Final stage: minimal runtime image
FROM ubuntu:22.04

# Install runtime dependencies only
RUN apt-get update && apt-get install -y \
    curl jq libssl1.1 \
    && rm -rf /var/lib/apt/lists/*

# Copy the binary from the builder stage
COPY --from=builder /app/evilginx /usr/local/bin/evilginx

# Expose port
EXPOSE 7000

# Start command
CMD ["evilginx"]
