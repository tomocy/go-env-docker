# syntax=docker/dockerfile:1.3

FROM --platform=${BUILDPLATFORM} golang:1.18.0-alpine3.15 as base
WORKDIR /src
ENV CGO_ENABLED=0
COPY go.* .
RUN go mod download
COPY . .

FROM base as build
ARG TARGETOS
ARG TARGETARCH
RUN --mount=type=cache,target=/root/.cache/go-build \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -o /out/example

FROM scratch as bin-unix
COPY --from=build /out/example /example

FROM bin-unix as bin-linux
FROM bin-unix as bin-darwin

FROM scratch as bin-windows
COPY --from=build /out/example /example.exe

FROM bin-${TARGETOS} as bin

FROM base as test
RUN --mount=type=cache,target=/root/.cache/go-build \
    go test -v .

FROM base as lint
COPY --from=golangci/golangci-lint:v1.45 /usr/bin/golangci-lint /usr/bin/golangci-lint
RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/root/.cache/golangci-lint \
    golangci-lint run --timeout 10m0s ./...
