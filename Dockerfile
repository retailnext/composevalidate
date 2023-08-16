FROM golang:1.21@sha256:e3669c57c750394adadbcc33528788b9ec142ccd433f8ff3407e52f21c68fd16 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:02f173c43cfc9fff9f6f82b498a92f735c400743683d96fcb9d8ba4797741b57

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
