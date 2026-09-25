FROM ghcr.io/securego/gosec:2.29.0@sha256:a6cd2f302b5f692e0b77b25751b299ddfbc0763a9711fa36e5a6bccd5292b0e8

RUN apk add --no-cache jq curl

COPY entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]
