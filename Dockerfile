FROM golang:1.23@sha256:ee5f0ad829b8a88be7689e04dc44eeb932857ba3299b5bb576ee2c0bab8963ff as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:fbc50a15b61eb0da6b935cd0c0f131bba1b34091ae67763527cd642f6049c563

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
