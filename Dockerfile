FROM golang:1.20@sha256:bc5f0b5e43282627279fe5262ae275fecb3d2eae3b33977a7fd200c7a760d6f1 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:454d4aa044420e73e83522a64dfff15a06682ba0448978bf94518dc1756fb707

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
