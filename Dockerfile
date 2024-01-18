FROM golang:1.21@sha256:5f5d61dcb58900bc57b230431b6367c900f9982b583adcabf9fa93fd0aa5544a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:c37f54d36db3096be7a81005e94d984355740e2b69577f6b715bf0a96930ff2c

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
