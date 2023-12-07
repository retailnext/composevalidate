FROM golang:1.21@sha256:58e14a93348a3515c2becc54ebd35302128225169d166b7c6802451ab336c907 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:005f610cf3694285399850804e7b6c83ce20829b2eee82eaf9be5ba834bece68

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
