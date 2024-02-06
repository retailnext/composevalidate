FROM golang:1.21@sha256:191676f3f6cb31c02232dfa2eaaf6b27b84c4efda73e47160ac86d49a91448fc as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:022a42744e8fc443d02c5ade74e75d2b8ad3bbab79144185723aa8d1097e07fd

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
