FROM golang:1.21@sha256:2ff79bcdaff74368a9fdcb06f6599e54a71caf520fd2357a55feddd504bcaffb as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ec3f6c069f320ad6f60ac2b0a3e5a47bfa11965b59f5948d671c18c581f071cd

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
