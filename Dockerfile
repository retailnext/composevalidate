FROM golang:1.23@sha256:cf5209fd902b5b22bbb79e20c35bccac5adbb08b235800d06f32c54237d8fcae as build

WORKDIR /go/src

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY ./ ./

RUN CGO_ENABLED=0 go build -o /go/bin/composevalidate -trimpath -ldflags="-s -w" .

FROM ghcr.io/regclient/regctl:alpine@sha256:0438daa1d058a178920ea105af06dfc4308cb693b889754409c014923d06535a

COPY --from=build /go/bin/composevalidate /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/composevalidate"]
