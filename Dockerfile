FROM golang:1.22@sha256:0b55ab82ac2a54a6f8f85ec8b943b9e470c39e32c109b766bbc1b801f3fa8d3b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:3e91e3a46641e290ca5d926115d5896819e31753feee9e4a0f547d919cbf2116

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
