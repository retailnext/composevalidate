FROM golang:1.21@sha256:ec457a2fcd235259273428a24e09900c496d0c52207266f96a330062a01e3622 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:081deb8240b3b1589ff00e1b0a9f0e008b6b9dc027728dd1349b6623d4d19210

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
