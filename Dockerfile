FROM golang:1.20@sha256:ff2cca5b02d31862041e57d6e622f97ed45a699bb70cf72aedbec1720ee3b585 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8c3033aa985fb34c973546c8a46f6a0f63c815cd9560487630fff5b58ace0dd2

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
