FROM golang:1.24@sha256:83d7392cb47ac13ce7ffce0dcbede5658087baf4dd79436831221153793791d5 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:a53cf4627ffa0e1bb1967d067bd6651505f81bfd03d8e53365cfedff9d940546

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
