FROM golang:1.20@sha256:20ee7c8a2be2fb81580e4db1b036c7237a363bac2d0f6b773e7291370d588d7b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8c3033aa985fb34c973546c8a46f6a0f63c815cd9560487630fff5b58ace0dd2

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
