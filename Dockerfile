FROM golang:1.21-alpine AS builder

# Install dependencies
RUN apk add --no-cache git build-base libssl-dev

WORKDIR /app

# Clone Evilginx v3 (stable)
RUN git clone https://github.com/kgretzzky/evilginx2.git .

# Build
RUN make

# Final stage
FROM alpine:3.18

RUN apk add --no-cache curl jq openssl

COPY --from=builder /app/evilginx /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]

