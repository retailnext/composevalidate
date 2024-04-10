FROM golang:1.22@sha256:f9129f959deef55db6c83b0e0dae069631a319cbd87317f077c34a282a95de19 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:6630ed9f511dbc44ffafd65cff6a8441b231eba7bf5f8f0cb2f8c0a1fe2119a4

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
