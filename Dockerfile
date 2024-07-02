FROM golang:1.22@sha256:800fde66644c2447abc2a085cbecdcb53d2e21234ec8e80be0c90fc011a93f4b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:2b7738c4db52df683884ce8f62fa5f3d4bf13ecd5f5de466814790d08a326f95

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
