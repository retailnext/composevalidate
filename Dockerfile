FROM golang:1.24@sha256:54528d189affe7ce60840cad093d53360705d47d71ea74d62eef72c476242fe9 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:7c14db799739547badbab4e733c8e9fa2c15251505c3c28e3a288f6054890a0b

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
