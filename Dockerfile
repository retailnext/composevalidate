FROM golang:1.21@sha256:fe54f55814913050d8d01cc6ffded67ae350594186b986fdba2ad02af58a6eb0 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:454d4aa044420e73e83522a64dfff15a06682ba0448978bf94518dc1756fb707

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
