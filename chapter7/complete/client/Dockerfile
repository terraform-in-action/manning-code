FROM golang:1.12 as builder
WORKDIR /go/src/github.com/team-pokemon/pikachu
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -v -o app

FROM alpine
RUN apk update && apk add --no-cache ca-certificates
COPY --from=builder /go/src/github.com/team-pokemon/pikachu/app /app
CMD ["/app"]