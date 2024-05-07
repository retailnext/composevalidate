FROM golang:1.22@sha256:992b9f6369a63bc8e8232a774a0279fe676e4f0393d63e4d945aacf268f66edf as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:7a8ab26aa7be8a78f87372f90599a9831d6f851ee7e900cffc1d5b318e898611

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
