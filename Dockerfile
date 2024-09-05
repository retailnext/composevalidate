FROM golang:1.23@sha256:acfb46be39840f8c2a6b9efdd673c6627011200c73bab4e6d18b8b9ab4641c46 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:0438daa1d058a178920ea105af06dfc4308cb693b889754409c014923d06535a

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
