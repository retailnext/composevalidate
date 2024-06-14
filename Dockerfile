FROM golang:1.22@sha256:a0679accac8685cc5389bd2298e045e570100940e6bdcca666a8ca7b32a1276c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:efca28aa5c1ffd88d151a6b0155c9d9336ecee9003a01147b93b6253a697cb02

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
