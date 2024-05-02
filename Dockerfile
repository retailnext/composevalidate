FROM golang:1.22@sha256:d5302d40dc5fbbf38ec472d1848a9d2391a13f93293a6a5b0b87c99dc0eaa6ae as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8d197402e835becd9da60724982f3b3a7864a799a1e900f38e9ad9771cc2385c

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
