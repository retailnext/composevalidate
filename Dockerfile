FROM golang:1.21@sha256:19600fdcae402165dcdab18cb9649540bde6be7274dedb5d205b2f84029fe909 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:2fb2c347f2abb49b728c491c906471971dd449549d9065f25adf62dfa2825d80

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
