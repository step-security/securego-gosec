FROM ghcr.io/securego/gosec:2.30.0@sha256:7bcf1edbab3e80d8006a28d53e7031a9c9775be8eec30679e4adc1f51d272121

RUN apk add --no-cache jq curl

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
