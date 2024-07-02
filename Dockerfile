FROM golang:1.22@sha256:3e731b22f6db4e5a76d957250d9a2bf9c2e2717ff7f97cfd20322e81ba185898 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:2b7738c4db52df683884ce8f62fa5f3d4bf13ecd5f5de466814790d08a326f95

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
