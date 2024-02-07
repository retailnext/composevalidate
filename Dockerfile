FROM golang:1.21@sha256:cc5f77892a716d63225adc27fb12f043b6e05bd1f653baab802938157bf12b10 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ae4710dc96a9d49f3d29c2d442ad1daf86bbe65c34ab087d9555382ad9e6af6f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
