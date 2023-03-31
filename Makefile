SHELL := /bin/bash

run:
	go run main.go

build:
	go build -ldflags "-X main.build=local" -o main

VERSION := 1.0

all: service

service:
	docker build \
	-f zarf/docker/Dockerfile \
	-t service-amd64:$(VERSION) \
	--build-arg BUILD_REF=$(VERSION) \
	--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	.



# =========================================================
# Running from within k8s/kind

KIND_CLUSTER := yelmi-starter-cluster
kind-up:
	kind create cluster \
		--image kindest/node:v1.25.3@sha256:f52781bc0d7a19fb6c405c2af83abfeb311f130707a0e219175677e366cc45d1 \
		--name $(KIND_CLUSTER)
		--config zarf/k8s/kind/kind-config.yaml
kind-load:
	kind load docker-image service-amd64:$(VERSION) --name $(KIND_CLUSTER)

kind-down:
	kind delete cluster --name $(KIND_CLUSTER)

kind-apply:
	cat zarf/k8s/base/service-pod/base-service.yaml | kubectl apply -f -

kind-status:
	kubectl get nodes -o wide
	kubectl get svc -o wide
	kubectl get pods -o wide --watch --all-namespaces