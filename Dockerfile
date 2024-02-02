FROM golang:1.21@sha256:7b575fe0d9c2e01553b04d9de8ffea6d35ca3ab3380d2a8db2acc8f0f1519a53 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:1611dd7ddd9dc429cc8377087a12993de4dee48ccbf034b27272643b35a153b3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
