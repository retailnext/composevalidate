FROM golang:1.21@sha256:3049cdf48ea2d2a0d9bb4621c0b22245c0e471fde2975416b58f4462c3b3de3a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:903e360b5fd1fac1a5a523b3c6edcab087c790f9081acc2d09eaaf585da66767

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
