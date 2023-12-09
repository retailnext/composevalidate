FROM golang:1.21@sha256:16aa78a5f734b2af158eb4582a1adb4dc48f51c28fb6b5478075242c3f8c0977 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:9ceac38afdae50bf67f87eef91dbd70f8e905c4c3e37cf9d7575a89035a8a00e

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
