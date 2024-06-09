FROM golang:1.22@sha256:969349b8121a56d51c74f4c273ab974c15b3a8ae246a5cffc1df7d28b66cf978 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:d0f1b1902524b099034686a9323c22a195709c9bacf35e7fe93f18947bc760a1

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
