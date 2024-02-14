FROM golang:1.22@sha256:cefea7fa6852b85f0042ce9d4b883c7e0b03b2bcb25972372d59e4f7c4367c04 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:d3b7033984adf170ae3a43bfce2989b06f6f650e90acc00e41a06dd3bc261381

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
