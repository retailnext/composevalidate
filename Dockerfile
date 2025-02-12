FROM golang:1.23@sha256:927112936d6b496ed95f55f362cc09da6e3e624ef868814c56d55bd7323e0959 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:58d6a03677cf2f37751b9ac527a2eb88deaf4582a03690096d6379db730eb844

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
