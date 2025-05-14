FROM ghcr.io/shopify/toxiproxy AS builder

FROM alpine:3.19

# Install minimal utilities
RUN apk add --no-cache bash

COPY --from=builder /toxiproxy /toxiproxy
COPY --from=builder /toxiproxy-cli /toxiproxy-cli

# Copy the startup script to the container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Use the script as the entrypoint
ENTRYPOINT ["/start.sh"]
