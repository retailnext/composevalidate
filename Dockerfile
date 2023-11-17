FROM golang:1.21@sha256:57bf74a970b68b10fe005f17f550554406d9b696d10b29f1a4bdc8cae37fd063 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ee0dcd2574a0437a2ea61ed72832c27ec0a7a4e532e51fe9510de43a3829322f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
