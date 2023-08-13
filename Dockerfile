FROM golang:1.21@sha256:ec457a2fcd235259273428a24e09900c496d0c52207266f96a330062a01e3622 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:bf9a5c9ce6d3cff7a6b0dd595e6a135312706ef6ebe114db78a87d9ede4b111c

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
