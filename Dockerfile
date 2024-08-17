FROM golang:1.23@sha256:613a108a4a4b1dfb6923305db791a19d088f77632317cfc3446825c54fb862cd as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:9a92e78ae8e05950f324f317aeb61ef0dfbf7e8e573c83a0fcf9950fb958c9ec

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
