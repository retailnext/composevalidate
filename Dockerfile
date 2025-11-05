FROM golang:1.25@sha256:516827db2015144cf91e042d1b6a3aca574d013a4705a6fdc4330444d47169d5 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:53115c38927846d4f2ae111121cca7e95a033fd84132d69569e814ede1a696d3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
