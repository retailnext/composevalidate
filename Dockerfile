FROM golang:1.23@sha256:26602182e32576fca9ad5397fd74b87ae68f7ee727436a85dd19a1c3766ad685 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:fbc50a15b61eb0da6b935cd0c0f131bba1b34091ae67763527cd642f6049c563

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
