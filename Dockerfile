FROM golang:1.22@sha256:82e07063a1ac3ee59e6f38b1222e32ce88469e4431ff6496cc40fb9a0fc18229 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:156ac02b10c2dc4d17135bd29ea31ae155e8dde70aa7ef89cfcf4529ef6b2eee

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
