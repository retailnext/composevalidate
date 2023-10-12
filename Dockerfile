FROM golang:1.21@sha256:f463b5e74f03088bbc145217143a02d06834072c80058affc5918ff78e1ed713 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:df8d9dcdfbb54d6ef67249ecbae4b92075e53db6255ad61fc21bc9c042ddeedb

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
