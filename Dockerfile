FROM golang:1.22@sha256:bb9d8c48543148d038e2d76ffcc12ee7c80d3cb0132b325c1983680ca04d320d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:fe61ea55119b80d8b07884fd02391eaa4101b84b440b0d760d588b40d5c1bee3

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
