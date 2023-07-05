FROM golang:1.20@sha256:7954299532c2a54dd5d68d81a34316d3a5d26029dd78bd40a11d001b9f79985d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8c3033aa985fb34c973546c8a46f6a0f63c815cd9560487630fff5b58ace0dd2

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
