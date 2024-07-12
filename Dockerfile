FROM golang:1.22@sha256:829eff99a4b2abffe68f6a3847337bf6455d69d17e49ec1a97dac78834754bd6 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8902087b1c66156bc813cb693f803b31190741709bb46765cba783d3d52956a6

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
