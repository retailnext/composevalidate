FROM golang:1.25@sha256:20b91eda7a9627c127c0225b0d4e8ec927b476fa4130c6760928b849d769c149 as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:b17293729b06c38bf0d9d7c9b16af418e4101ebde95a3462b9a863daecac72f5

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
