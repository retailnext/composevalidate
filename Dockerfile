FROM golang:1.22@sha256:e4292aeda6e15a875bd602d1c539bada547b72b04bce769dd32ac833337eb4bf as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:2b7738c4db52df683884ce8f62fa5f3d4bf13ecd5f5de466814790d08a326f95

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
