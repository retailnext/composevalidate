FROM golang:1.23@sha256:540d3442f4758da82e787d03930bf6468cf6f8613474135e8946259b9e531ea0 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:0438daa1d058a178920ea105af06dfc4308cb693b889754409c014923d06535a

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
