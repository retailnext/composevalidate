FROM golang:1.24@sha256:18a1f2d1e1d3c49f27c904e9182375169615c65852ace724987929b910195b2c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:9aa2a8c71b6f687aad188475162bd6c4c00366c19ba648ae6c70018d096c92ab

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
