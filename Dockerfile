FROM golang:1.21@sha256:970907c870214ecc19784036f9ba93414213473b03c2b0dc1fa90eeb3a563b8f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:5c209ebfc33c088b9824071d0126bcf547e9b88f25f268004777a2b8aa3b1ee9

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
