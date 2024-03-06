#!/bin/bash

# Variables
cluster_name=""
namespace=""
region=""
repo_name=""
# End Variables

# delete Docker-img from ECR
echo "--------------------Deleting ECR-IMG--------------------"
aws ecr batch-delete-image --repository-name $repo_name --image-ids imageTag=latest

# delete database secret
echo "--------------------Deleting DB Secret--------------------"
kubectl delete -n $namespace secret db-password-secret

# delete deployment
echo "--------------------Deleting Deployment--------------------"
kubectl delete -n $namespace -f k8s/

# delete namespace
echo "--------------------Deleting Namespace--------------------"
kubectl delete ns $namespace

# delete AWS resources
echo "--------------------Deleting AWS Resources--------------------"
cd terraform && \
terraform destroy -auto-approve