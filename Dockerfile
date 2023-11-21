FROM golang:1.21@sha256:3bd80b1ac6df79b9ae76313048f59ef989ffcd7647a517de2c65db5c95934425 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:457794f38b08ebf4f6f2dcb046d304aba875b938b37a8b0a251c808e6afd0572

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
