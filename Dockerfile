FROM golang:1.21@sha256:672a2286da3ee7a854c3e0a56e0838918d0dbb1c18652992930293312de898a6 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ecf182103de0112bff790f59c283e5777f58f3c952e3f0acd6d4629bce79dba5

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
