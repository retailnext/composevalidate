FROM golang:1.21@sha256:ec457a2fcd235259273428a24e09900c496d0c52207266f96a330062a01e3622 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:454d4aa044420e73e83522a64dfff15a06682ba0448978bf94518dc1756fb707

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
