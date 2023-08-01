FROM golang:1.20@sha256:010a0ffe47398a3646993df44906c065c526eabf309d01fb0cbc9a5696024a60 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:97d66f4fe68446f911a7181d4e575125c3f802c605ecf12492d72d65a2d062e7

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
