FROM golang:1.21@sha256:6fbd2d3398db924f8d708cf6e94bd3a436bb468195daa6a96e80504e0a9615f2 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:81eeabd1b15f2e9d612d31088d5481c8d5dc8deedb36923a03b34d4d6d920414

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
