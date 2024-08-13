FROM golang:1.22@sha256:305aae5c6d68e9c122246147f2fde17700d477c9062b6724c4d182abf6d3907e as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:fe61ea55119b80d8b07884fd02391eaa4101b84b440b0d760d588b40d5c1bee3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
