# README: Toxiproxy Docker Image for Simulating Latency on Database Calls

## Overview:

This project provides a Docker image for Toxiproxy, a tool used to simulate network conditions like latency, slowdowns, or other failures on database calls. It allows you to inject artificial delays into requests, helping you test how your system behaves under unreliable network conditions.

Key Features:
*    Simulate slow network or latency on database calls

 *  Simulate a black-box failure by introducing delays, timeouts, or connection drops

  * Flexible configuration for different services (e.g., MySQL, APIs)

## Breakdown

### Dockerfile
```Dockerfile
# Use existing toxiproxy image
FROM ghcr.io/shopify/toxiproxy AS builder

FROM alpine:3.19

# Install bash for entrypoint multi-commands
RUN apk add --no-cache bash

# Get executable from toxiproxy image
COPY --from=builder /toxiproxy /toxiproxy
COPY --from=builder /toxiproxy-cli /toxiproxy-cli

# Start Toxiproxy and configure proxy with delay
ENTRYPOINT ["/bin/sh", "-c"]

# 1000ms of delay on call to 0.0.0.0:3306
CMD ["/toxiproxy & sleep 2 && /toxiproxy-cli -h 127.0.0.1:8474 create -l 0.0.0.0:3307 -u 0.0.0.0:3306 mysql_proxy && /toxiproxy-cli -h 127.0.0.1:8474 toxic add -t latency -a latency=1000 mysql_proxy && tail -f /dev/null"]

```

I used this multi stage approach as the `toxiproxy` image does not have `bash` so the `sh -c` is not available to quick configuration on `docker-compose`
This way, the `CMD` can be overwritten through `docker-compose.yml`

## Conclusion

This Toxiproxy setup helps simulate slow or unreliable network conditions for testing your application’s resilience in real-world scenarios

**Disclamer: this text has been mostly generated by AI**

