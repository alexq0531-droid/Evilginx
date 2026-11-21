FROM golang:1.19-alpine AS builder

# Install git and build tools
RUN apk add --no-cache git build-base libssl-dev

WORKDIR /src

# Clone Evilginx v3.4.0
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Build with strict memory limits to prevent OOM on Render Free Tier
ENV CGO_ENABLED=1
ENV GOGC=25
RUN make PARALLELISM=1

# Final stage
FROM alpine:3.18

RUN apk add --no-cache curl jq openssl

COPY --from=builder /src/evilginx /usr/local/bin/evilginx

EXPOSE 7000

CMD ["evilginx"]

