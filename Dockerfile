FROM golang:1.21@sha256:84e41b3ab4066cc8a77ac30ddb054de99d4f0048b0392376da20d2a072c5862d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:b04ca52bf67945adfd4cf8e32b49d6350d3379123f43da6bdacb559fec7eb609

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
