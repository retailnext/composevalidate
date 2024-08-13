FROM golang:1.22@sha256:bb9d8c48543148d038e2d76ffcc12ee7c80d3cb0132b325c1983680ca04d320d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:134f5437bb246a129354e3708474c6d520fdf05526b7346769496bf0c15762a0

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
