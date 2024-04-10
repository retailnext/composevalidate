FROM golang:1.22@sha256:83d3f5ddeb0687a6fe2ffad3c76397f5e4d0a30d35fc4a5262e28dd52e6f7d7d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:6630ed9f511dbc44ffafd65cff6a8441b231eba7bf5f8f0cb2f8c0a1fe2119a4

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
