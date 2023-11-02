FROM golang:1.21@sha256:520687355000760907fa2d95c3387114fe72a2fb5873e6803d03bdf0e8ef35fa as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:b04ca52bf67945adfd4cf8e32b49d6350d3379123f43da6bdacb559fec7eb609

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
