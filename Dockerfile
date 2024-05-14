FROM golang:1.22@sha256:67c386d58c48816114d4264145127a684b4cd0969355fd6481f5a846fe85a497 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:d7da22550d01bee8318ac3946a4b5e0b3b8045fcea23ee201b97f82f5995b8d3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
