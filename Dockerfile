FROM golang:1.21@sha256:fb02af54c90379fc747f468b9d4a4701be8bcbbdefe87b15377e47362222fa80 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8cb6fde23a0538a40b447c8a74b8f98ba6108fadf75b138fa5570607e280c90f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
