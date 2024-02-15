FROM golang:1.22@sha256:cefea7fa6852b85f0042ce9d4b883c7e0b03b2bcb25972372d59e4f7c4367c04 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:346a802a5a1f74afbe795f56a529d25147538a871192673182a5acb99c07c041

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
