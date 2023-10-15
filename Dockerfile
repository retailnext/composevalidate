FROM golang:1.21@sha256:24a09375a6216764a3eda6a25490a88ac178b5fcb9511d59d0da5ebf9e496474 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:dc2c5d3b37422edbba7a50e7aa51ea72f956f17e44deb6acddbaea8290b251b2

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
