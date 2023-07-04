FROM golang:1.20@sha256:721bc0e496f849ebefc30f9caf48864574cc9b02a7b47a21d34f88087fb0cf00 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ab047fa7cbe3255346563ba7aeb4a4bfe7a2ddf7932943a003a5c0b9e16705ae

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
