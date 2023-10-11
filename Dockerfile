FROM golang:1.21@sha256:02d7116222536a5cf0fcf631f90b507758b669648e0f20186d2dc94a9b419a9b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:df8d9dcdfbb54d6ef67249ecbae4b92075e53db6255ad61fc21bc9c042ddeedb

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
