FROM golang:1.21@sha256:cffaba795c36f07e372c7191b35ceaae114d74c31c3763d442982e3a4df3b39e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:f490324d9eac9007a1322b9a913555975e8cb1be2822c19a2da3a106d243e403

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
