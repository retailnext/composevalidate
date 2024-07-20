FROM golang:1.22@sha256:829eff99a4b2abffe68f6a3847337bf6455d69d17e49ec1a97dac78834754bd6 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ae5a1d2ec5cb51f74b4a019cea52fd7c7e8696c165c23a3cc3a65a94ab3b8d95

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
