FROM golang:1.22@sha256:c2010b9c2342431a24a2e64e33d9eb2e484af49e72c820e200d332d214d5e61f as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:6dac3f03ee0616b38c7c18f61aa70b71df5e4e857cf2fc6f627d5a7f997f9773

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
