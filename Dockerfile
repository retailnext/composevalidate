FROM golang:1.22@sha256:a579ba867398ad2e4d5db86f66c2c098cd047d0cbf72459bd59beaff7cba179d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:18ecc5424d7e90aa8d9b6f0d4929000e711bde0fbd4a86c3f9aa49a0579e7496

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
