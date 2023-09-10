FROM golang:1.21@sha256:d2aad22fc6f1017aa568d980b15d0067a721c770be47b9dc62b11c33487fba64 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:b210954b05f2e53301ced8d36be4222c6ceca6b74e4d671120597ebeeeb9aa9d

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
