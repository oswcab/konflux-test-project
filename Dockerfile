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
FROM registry.access.redhat.com/ubi10-micro:10.3-1794483856@sha256:2ad0f98cb13160c4773c945ef93f88b25831c7f27cd3780d72a7e78b210ea72b
COPY --from=builder /opt/app-root/src/main /
USER 65532:65532

ENV PORT 8081
EXPOSE 8081

CMD [ "./main" ]
# konflux-test trigger run-308306bc-2cd7-42b6-bca1-5606229156cb 1793389736
# konflux-test trigger run-9957b434-9cc7-41f2-839d-9eac4706f700 1793623013
