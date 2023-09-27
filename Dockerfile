FROM golang:1.21@sha256:19600fdcae402165dcdab18cb9649540bde6be7274dedb5d205b2f84029fe909 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:add2368ac26316a38a5e7177686097514a80b50fcbffcaf3f2dce42ad1a1ea69

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
