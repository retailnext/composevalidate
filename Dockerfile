FROM golang:1.21@sha256:e9ebfe932adeff65af5338236f0b0604c86b143c1bff3e1d0551d8f6196ab5c5 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:df8d9dcdfbb54d6ef67249ecbae4b92075e53db6255ad61fc21bc9c042ddeedb

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
