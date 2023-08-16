FROM golang:1.21@sha256:2c2a2a1250bee062627a39cc78a4fc96cb84fe0c0f55f2d83249c70e1edbcd42 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:02f173c43cfc9fff9f6f82b498a92f735c400743683d96fcb9d8ba4797741b57

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
