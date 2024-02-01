FROM golang:1.21@sha256:0c22572a0b01ce93bb9d1f0bea2f198b6b827225a194a1f3a185d0fd4b4513b7 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:99bd79bf4f6cfb7c3393b1da832ebc1a99f9e2555d7e8bc279acaf37270bfa76

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
