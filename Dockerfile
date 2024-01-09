FROM golang:1.21@sha256:060bb97e8522413ade197f6abe001b7d75412ba4d0a8edc26b21170dda954da7 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:447cddf1e10e019192e803a301e3125e9401c3522b88a7186ca959de78eba6a1

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
