FROM golang:1.24@sha256:62c7ec2059c165fee0750d3ee51429d6c167749f70dd13b7dfea2c85dfd941de as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:53115c38927846d4f2ae111121cca7e95a033fd84132d69569e814ede1a696d3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
