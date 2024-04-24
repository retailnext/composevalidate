FROM golang:1.22@sha256:a579ba867398ad2e4d5db86f66c2c098cd047d0cbf72459bd59beaff7cba179d as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:2882118dfe9450fa490e9e8abb07ea0cfc5cb0bf5494ddc7b1a08a1dae5d1397

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
