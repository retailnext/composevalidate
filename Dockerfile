FROM golang:1.22@sha256:094e47ef90125eb49dfbc67d3480b56ee82ea9b05f50b750b5e85fab9606c2de as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ae4710dc96a9d49f3d29c2d442ad1daf86bbe65c34ab087d9555382ad9e6af6f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
