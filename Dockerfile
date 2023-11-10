FROM golang:1.21@sha256:81cd210ae58a6529d832af2892db822b30d84f817a671b8e1c15cff0b271a3db as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:39e77079a6fecc213fa62a0abc51d89ca99e7533a2b8d2bc384c0d78dac219b8

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
