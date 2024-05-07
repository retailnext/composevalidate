FROM golang:1.22@sha256:992b9f6369a63bc8e8232a774a0279fe676e4f0393d63e4d945aacf268f66edf as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:e131c9d118393eaa76ed0ede590ab228b818c164a88805d6ecc5e66a7e588d69

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
