FROM golang:1.20@sha256:8e5a0067e6b387263a01d06b91ef1a983f90e9638564f6e25392fd2695f7ab6c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:b799cf0ed1e7f7ed69069929d7ce5094094d7eaa382a5e4aa616855ee883bb8f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
