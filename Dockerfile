FROM golang:1.21@sha256:81cd210ae58a6529d832af2892db822b30d84f817a671b8e1c15cff0b271a3db as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ecb47362ffb6589ac47c69c206adbf6d89b9fa5c05e9730412e38b683028fc6e

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
