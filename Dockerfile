FROM golang:1.22@sha256:87bbc3e8e2c7cb625d09ed4c3ae4663e3ba4e64c6e59797a7ec1e3da7d972f7b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:1c40ee4a57fe1deb41b152af95930a8887af3c7b8b9dd3bcecd46a8fe2ff65fd

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
