FROM registry.access.redhat.com/ubi10/go-toolset:10.1-1768450804@sha256:dc5382397fb172597021857190de7354e40e375d25f2e434318d7c3272b45c39 AS builder

# Copy the Go Modules manifests
COPY go.mod go.mod
# cache deps before building and copying source so that we don't need to re-download as much
# and so that source changes don't invalidate the downloaded layers
RUN go mod download

# Copy the go source
COPY main.go main.go

# Build
RUN CGO_ENABLED=0 go build -a -o main main.go

# Runtime stage
FROM registry.access.redhat.com/ubi10-micro:10.2-1792455530@sha256:1c105e547de5d9e0bc20d06ebabee73b20bc6bba994c50ae3e207684fd8bef2b
COPY --from=builder /opt/app-root/src/main /
USER 65532:65532

ENV PORT 8081
EXPOSE 8081

CMD [ "./main" ]
