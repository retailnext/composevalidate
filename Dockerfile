FROM golang:1.21@sha256:15186806b8ca1b8e751ad6bf60b4f16cd9669b3c3dd2a83c9536a78a0e1fea8a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:81eeabd1b15f2e9d612d31088d5481c8d5dc8deedb36923a03b34d4d6d920414

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
