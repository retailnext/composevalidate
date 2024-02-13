FROM golang:1.22@sha256:00ae06c880f116b86c7524862ab5ac5c44ed4d3d4a8749df78d955f922595b25 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:d3b7033984adf170ae3a43bfce2989b06f6f650e90acc00e41a06dd3bc261381

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
