FROM golang:1.22@sha256:695e2559491efb2cc266226501b128eb6b4923d388f55ec182e1d96f65955a2a as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:7a41dc6033b4094fbcea643ed044862755df57dc145c98c769fdf97a98b5e243

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
