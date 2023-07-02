FROM golang:1.20@sha256:344193a70dc3588452ea39b4a1e465a8d3c91f788ae053f7ee168cebf18e0a50 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:9a2d3ad272d2394cfefc51eb73e28f669f9fa7596a40e4c5c0a82b5055eb5127

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
