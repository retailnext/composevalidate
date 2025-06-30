FROM golang:1.24@sha256:18a1f2d1e1d3c49f27c904e9182375169615c65852ace724987929b910195b2c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:9e5b4ad04dd7ee9b37b360289231eb4ebadfe3a72f3ddaa1cd6a585efb6d1e4c

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
