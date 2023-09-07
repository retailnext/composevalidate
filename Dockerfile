FROM golang:1.21@sha256:1c545bb2b085f60435dfffb884a1c831d8b1a7fd9b4a1bf58715113d70c305b5 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:5c209ebfc33c088b9824071d0126bcf547e9b88f25f268004777a2b8aa3b1ee9

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
