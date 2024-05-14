FROM golang:1.22@sha256:72e8f4d661b29c3974572ee8add5cf99985804a85cd5678b912c5b2a4002c56f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:d7da22550d01bee8318ac3946a4b5e0b3b8045fcea23ee201b97f82f5995b8d3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
