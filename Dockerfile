FROM golang:1.21@sha256:1a9d253b11048b1c76b690b0c09d78d200652e4e913d5d1dcc8eb8d0d932bfe4 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8cb6fde23a0538a40b447c8a74b8f98ba6108fadf75b138fa5570607e280c90f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
