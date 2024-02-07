FROM golang:1.21@sha256:191676f3f6cb31c02232dfa2eaaf6b27b84c4efda73e47160ac86d49a91448fc as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:ae4710dc96a9d49f3d29c2d442ad1daf86bbe65c34ab087d9555382ad9e6af6f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
