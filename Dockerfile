FROM golang:1.22@sha256:829eff99a4b2abffe68f6a3847337bf6455d69d17e49ec1a97dac78834754bd6 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:734978a0fd345d1a7e9fbe04307dff55dbfa691aca5772cfeb3f53d688f8f92b

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
