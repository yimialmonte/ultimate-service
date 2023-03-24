# Build the Go Binary
FROM golang:1.19 as build_sales-api
ENV CGO_ENABLE 0
ARG BUILD_REF

# Copy the source code into the container
COPY . /service

# Build the service binary
WORKDIR /service
RUN go build -ldflags "-X main.build=${BUILD_REF}"

# Run the Go binary
FROM alpine:3.14
ARG BUILD_DATE
ARG BUILD_REF
COPY --from=build_sales-api /service /service/service
WORKDIR /service
CMD ["./service"]

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.title="sales-api" \
      org.opencontainers.image.authors="Yelmi Almonte" \
      org.opencontainers.image.revision="${BUILD_REF}" \
      org.opencontainers.image.vendor="Org"