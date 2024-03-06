#!/bin/bash

# Variables
cluster_name=""
region="us-east-1"
aws_id=""
repo_name=""
image_name=""
namespace="nodejs"

# Update Helm
helm repo update

# Build infrastructure
cd terraform && \
terraform init 
terraform apply --auto-approve
cd ..

echo "Update kube-config"
aws eks update-kubeconfig --name $cluster_name --region $region

echo "Removing previous image"
docker rmi -f $image_name || true

echo "Build image"
docker build -t $image_name ./app/

echo "ECR login"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_id.dkr.ecr.$region.amazonaws.com

echo "Push docker image"
docker push $image_name

echo "Create namespace"
kubectl create namespace $namespace || true

echo "Deploy app"
kubectl apply -n $namespace -f k8s
