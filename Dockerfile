FROM golang:1.20@sha256:690e4135bf2a4571a572bfd5ddfa806b1cb9c3dea0446ebadaf32bc2ea09d4f9 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:8946dfb6aa44af4985701d0ad0fb740de7c500e6ae5c7a6300dbcb800a84a17c

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
