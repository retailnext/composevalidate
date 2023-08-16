FROM golang:1.21@sha256:a820bbba79cb17845f259d86b5342a4854b1f62b654172b68ba7446bd9c1319e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:02f173c43cfc9fff9f6f82b498a92f735c400743683d96fcb9d8ba4797741b57

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
