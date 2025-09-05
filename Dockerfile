FROM golang:1.24@sha256:cb7fdea164b91136192c2f1688172a88da56fd3fac88d0795b8e8ed975fd2966 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:53115c38927846d4f2ae111121cca7e95a033fd84132d69569e814ede1a696d3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
