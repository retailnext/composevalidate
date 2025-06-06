FROM golang:1.24@sha256:db5d0afbfb4ab648af2393b92e87eaae9ad5e01132803d80caef91b5752d289c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:e50f92394d7826dde8f6558511178988b4ce64267519b8b0a9c6c47fbeae6a16

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
