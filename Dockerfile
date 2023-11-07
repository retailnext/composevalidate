FROM golang:1.21@sha256:692e8304e82d448d795d9f2b27b8945881f45618ee9e9f9a1f1f6ad6b365860c as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:668b580ce8f4a6c1e5c5762acfd0d1bb0309626682f673974dffe865ffb8d35b

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
