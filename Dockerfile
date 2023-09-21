FROM golang:1.21@sha256:cb68d581d97423562b0a4416514866854c0b28a863b6feac929a54a73412fdfd as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:7dba25d1907e22b766113bebe7fd3ffd8a0fd8d2f2575546cbed94234af8119f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
