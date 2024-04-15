FROM golang:1.22@sha256:450e3822c7a135e1463cd83e51c8e2eb03b86a02113c89424e6f0f8344bb4168 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:18ecc5424d7e90aa8d9b6f0d4929000e711bde0fbd4a86c3f9aa49a0579e7496

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
