# DevOps Deployment System (Blue-Green + Canary)

## Overview

This project demonstrates a production-style deployment system using Docker and modern DevOps practices.

It implements Blue-Green and Canary deployment strategies with the goal of achieving zero downtime and safe rollbacks.

## Features

* Blue-Green deployment
* Canary deployment
* Docker-based containerization
* Traffic routing using Nginx
* Rollback capability (in progress)
* Kubernetes migration (in progress)

## Tech Stack

* Linux (Debian)
* Docker
* Nginx
* Kubernetes (Minikube)
* GitHub

## Project Structure

* docker/ → container setup and configurations
* k8s/ → Kubernetes setup and experiments
* (more coming…)

## How It Works

1. Two versions of the application (blue & green) run in parallel
2. Traffic is routed using Nginx
3. Deployment strategy determines which version receives traffic
4. Rollback is possible if issues are detected

## Kubernetes (Ongoing Work)

Currently migrating this setup to Kubernetes for:

* better scalability
* self-healing
* automated deployment

See `/k8s` folder for progress.

## Future Improvements

* CI/CD pipeline integration
* Monitoring with Prometheus & Grafana
* Full Kubernetes-based deployment

## Author

ROOPUS V

