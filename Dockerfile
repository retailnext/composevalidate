FROM golang:1.21@sha256:81cd210ae58a6529d832af2892db822b30d84f817a671b8e1c15cff0b271a3db as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:3d2a94d165bce2622aa9c33c31d90b2f6a9916d26f4de1acb2c70574f04de6fa

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
