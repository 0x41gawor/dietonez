FROM golang:1.24.1-alpine

WORKDIR /dietonez

COPY go.mod ./
COPY go.sum ./
COPY ./cmd ./cmd
COPY ./internal ./internal
COPY Makefile ./
COPY openapi.yaml ./
COPY swagger-ui ./swagger-ui

RUN go mod download
RUN apk add --no-cache make
RUN make build

EXPOSE 8080

CMD ["./bin/dietonez"]