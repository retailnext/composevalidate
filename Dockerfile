FROM golang:1.21@sha256:a0e3e6859220ee48340c5926794ce87a891a1abb51530573c694317bf8f72543 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:454d4aa044420e73e83522a64dfff15a06682ba0448978bf94518dc1756fb707

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
