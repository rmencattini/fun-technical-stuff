FROM ghcr.io/shopify/toxiproxy AS builder

FROM alpine:3.19

# Install minimal utilities
RUN apk add --no-cache bash

COPY --from=builder /toxiproxy /toxiproxy
COPY --from=builder /toxiproxy-cli /toxiproxy-cli

# Start Toxiproxy and configure proxy with delay
ENTRYPOINT ["/bin/sh", "-c"]

CMD ["/toxiproxy & sleep 2 && /toxiproxy-cli -h 127.0.0.1:8474 create -l 0.0.0.0:3307 -u mysql:3306 mysql_proxy && /toxiproxy-cli -h 127.0.0.1:8474 toxic add -t latency -a latency=1000 mysql_proxy && tail -f /dev/null"]
