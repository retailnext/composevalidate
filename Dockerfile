FROM golang:1.21@sha256:191676f3f6cb31c02232dfa2eaaf6b27b84c4efda73e47160ac86d49a91448fc as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:edge-alpine@sha256:82c6a8f84bc60c3633a111ba454f32e8652909493a6a55cbf725d0766986625f

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
