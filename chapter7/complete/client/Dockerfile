FROM golang:1.12 as builder
WORKDIR /go/src/github.com/scottwinkler/helloworld
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o helloworld

FROM alpine
RUN apk update && apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/scottwinkler/helloworld/helloworld /helloworld
CMD ["/helloworld"]