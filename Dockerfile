FROM golang:1.24@sha256:18a1f2d1e1d3c49f27c904e9182375169615c65852ace724987929b910195b2c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:31972bd10bfb44b505fd77e379855078b8064e2baa087dce77d7dc7823236684

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
