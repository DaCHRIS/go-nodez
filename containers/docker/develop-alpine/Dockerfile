FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/NodezCrypto/go-nodez && \
  (cd go-nodez && make ndz) && \
  cp go-nodez/build/bin/ndz /ndz && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-nodez && rm -rf /var/cache/apk/*

EXPOSE 7331
EXPOSE 13373

ENTRYPOINT ["/ndz"]
