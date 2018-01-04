# Build Nodez in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-nodez
RUN cd /go-nodez && make ndz

# Pull Nodez into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-nodez/build/bin/ndz /usr/local/bin/

EXPOSE 7331 8546 13373 13373/udp 30304/udp
ENTRYPOINT ["ndz"]
