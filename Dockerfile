FROM golang:1.21@sha256:9baee0edab4139ae9b108fffabb8e2e98a67f0b259fd25283c2a084bd74fea0d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:fd56f44ca7bfec8b151e308c4407b2cbe1b2caef01fcfccb872238b02ee41dbf

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
