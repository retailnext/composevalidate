FROM golang:1.21@sha256:3c871baacaa9db01d5b7e26b6ae937b695fbc87287696d67341a4a0f29c31230 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:99bd79bf4f6cfb7c3393b1da832ebc1a99f9e2555d7e8bc279acaf37270bfa76

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
