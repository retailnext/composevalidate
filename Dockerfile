FROM golang:1.24@sha256:44472c2f52cc647f447febbd5520ecd1eeebf6738a5d7e44a2392dcb53e3a60a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:7c14db799739547badbab4e733c8e9fa2c15251505c3c28e3a288f6054890a0b

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
