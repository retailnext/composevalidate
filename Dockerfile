FROM golang:1.23@sha256:10b592536be3c473fb0fb588b5018f203af53e6c2ebb478c7fa813939416f802 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:fbc50a15b61eb0da6b935cd0c0f131bba1b34091ae67763527cd642f6049c563

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
