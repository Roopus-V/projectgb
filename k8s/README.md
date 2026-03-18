# Kubernetes Setup (Work in Progress)

## Day 1 Progress

* Installed Minikube
* Started local Kubernetes cluster
* Created first deployment (nginx)
* Exposed deployment using NodePort service
* Accessed application in browser

## Commands Used

kubectl create deployment nginx-deployment --image=nginx
kubectl get pods
kubectl expose deployment nginx-deployment --type=NodePort --port=80
minikube service nginx-deployment

## Key Learnings

* Pod is the smallest unit in Kubernetes
* Deployment manages pods
* Service exposes pods to external access
* Minikube runs a local Kubernetes cluster

## Next Steps

* Scale pods
* Understand rolling updates
* Migrate green/blue deployment to Kubernetes

## Kubernetes (In Progress)

Currently migrating deployment system to Kubernetes.

See /k8s folder for details.
