FROM golang:1.23@sha256:f06d2bb355a67ccc6c23f3699766323a09ed0a4b724a6b25a300d4b30e01f02c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:8f2362ee3fc8e22d1a65824a8f461bb0e61673b8ef7f8726cb6af719fcf919a3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
