FROM golang:1.21@sha256:c416ceeec1cdf037b80baef1ccb402c230ab83a9134b34c0902c542eb4539c82 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:dc786ac8c22505ff0156eb8430331873773cb46c0ce86448ae81e96460849cef

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
