FROM golang:1.21@sha256:ae34fbf671566a533f92e5469f3f3d34e9e6fb14c826db09956454da9a84c9a9 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ec3f6c069f320ad6f60ac2b0a3e5a47bfa11965b59f5948d671c18c581f071cd

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
