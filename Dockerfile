FROM golang:1.22@sha256:82e07063a1ac3ee59e6f38b1222e32ce88469e4431ff6496cc40fb9a0fc18229 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:c103c73b10cc9792e47cdb6f833f51ceef4071fc265353fd82c16d5f67b19f06

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
