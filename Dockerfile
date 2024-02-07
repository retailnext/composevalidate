FROM golang:1.21@sha256:cc5f77892a716d63225adc27fb12f043b6e05bd1f653baab802938157bf12b10 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:82c6a8f84bc60c3633a111ba454f32e8652909493a6a55cbf725d0766986625f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
