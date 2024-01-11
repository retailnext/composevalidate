FROM golang:1.21@sha256:ffbb0b828ddd29d539681b6749255989c394a5b11a2b460018c1bc87e0d93a52 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:5605a699e1d9dab1a374b837a58c8b153179bc8b96bc501f3669896262ed7ff8

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
