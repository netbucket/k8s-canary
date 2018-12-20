#!/bin/bash
#
# Build the k8s-canary Docker images. Based on httpr - see https://github.com/netbucket/httpr/
#
IMAGE_PLAINTEXT="netbucket/k8s-canary"
IMAGE_HTTPS="netbucket/k8s-canary-https"
VERSION="1.0.0"

# Build and push the plaintext/HTTP version
docker build . -f Dockerfile -t $IMAGE_PLAINTEXT:$VERSION -t $IMAGE_PLAINTEXT:latest
docker push $IMAGE_PLAINTEXT:$VERSION
docker push $IMAGE_PLAINTEXT:latest

# Build and push the TLS/HTTPS version
docker build . -f Dockerfile.https -t $IMAGE_HTTPS:$VERSION -t $IMAGE_HTTPS:latest
docker push $IMAGE_HTTPS:$VERSION
docker push $IMAGE_HTTPS:latest
