FROM golang:1.21@sha256:2270a408c4cb38f8459839082d89afa4a2870773c509adf7641e9558167d0030 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:7dba25d1907e22b766113bebe7fd3ffd8a0fd8d2f2575546cbed94234af8119f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
