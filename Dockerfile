FROM golang:1.21@sha256:8144f2d44d2262fa930b437200fc4ada624d8a0b9c83d688e2a6f545d097c45b as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ae4710dc96a9d49f3d29c2d442ad1daf86bbe65c34ab087d9555382ad9e6af6f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
