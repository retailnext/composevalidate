FROM golang:1.22@sha256:6a02cc10cb339f7fdb0feace29e0db457f0b84641cd030a3ada30964390af625 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:c103c73b10cc9792e47cdb6f833f51ceef4071fc265353fd82c16d5f67b19f06

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
