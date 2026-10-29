FROM registry.access.redhat.com/ubi10/go-toolset:10.2-1793232609@sha256:5d2ab83e88506afee6bcc909fdab425ab979725ab30d6ad43a02aaa77e2258ff AS builder

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
FROM registry.access.redhat.com/ubi10-micro:10.1-1766049088@sha256:2946fa1b951addbcd548ef59193dc0af9b3e9fedb0287b4ddb6e697b06581622
COPY --from=builder /opt/app-root/src/main /
USER 65532:65532

ENV PORT 8081
EXPOSE 8081

CMD [ "./main" ]
