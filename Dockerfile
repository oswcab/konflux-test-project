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
FROM registry.access.redhat.com/ubi10-micro:10.2-1791441953@sha256:5b13e670e107509be71c066180032017ff5dddff2b6cd60d16311a5cea309953
COPY --from=builder /opt/app-root/src/main /
USER 65532:65532

ENV PORT 8081
EXPOSE 8081

CMD [ "./main" ]
