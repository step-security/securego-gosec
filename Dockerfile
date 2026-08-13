FROM ghcr.io/securego/gosec:2.28.0

RUN apk add --no-cache jq curl

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
