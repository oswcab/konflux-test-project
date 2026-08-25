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
FROM registry.access.redhat.com/ubi10-micro:10.2-1787684489@sha256:37fadb004c6bea628fcdd81376c8fb77bd8d9fd432d90503af4d9e76b1ff7191
COPY --from=builder /opt/app-root/src/main /
USER 65532:65532

ENV PORT 8081
EXPOSE 8081

CMD [ "./main" ]
