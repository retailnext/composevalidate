FROM golang:1.23@sha256:d7b4cfdee0b5e884694c08fbb61e0a1c3788559977dadb6051f45aac75d4bbdb as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:0438daa1d058a178920ea105af06dfc4308cb693b889754409c014923d06535a

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
