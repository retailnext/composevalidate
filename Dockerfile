FROM golang:1.21@sha256:19600fdcae402165dcdab18cb9649540bde6be7274dedb5d205b2f84029fe909 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:30be95238a399e6489e2813ddd064b3ea517c6ac137045e9d706b3a0a481b7ab

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
