FROM golang:1.21@sha256:58e14a93348a3515c2becc54ebd35302128225169d166b7c6802451ab336c907 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:9ceac38afdae50bf67f87eef91dbd70f8e905c4c3e37cf9d7575a89035a8a00e

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
