FROM golang:1.25@sha256:a22b2e6c5e753345b9759fba9e5c1731ebe28af506745e98f406cc85d50c828e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:7c14db799739547badbab4e733c8e9fa2c15251505c3c28e3a288f6054890a0b

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
