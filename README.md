# CICD 2048 Game

## 🌟 Overview
This project focuses on setting up a CI/CD pipeline for deploying a Dockerized version of the 2048 game to AWS. The pipeline automates the process of building, testing, and deploying the game to a scalable infrastructure using Amazon ECS, Amazon ECR, and AWS CodePipeline.

## 🛠️ Services used
* **AWS CodePipeline**: Orchestrates the CI/CD pipeline, automating the build, test, and deployment stages. **[Automation]**
* **Amazon ECS**: Deploys and manages containerized applications using Fargate for serverless container management. **[Deployment]**
* **Amazon ECR**: Stores and manages Docker images used in the ECS tasks. **[Container Registry]** 
* **AWS CodeBuild**: Handles the build phase of the pipeline, including Docker image creation. **[Build]**
* **IAM Roles & Policies**: Ensure secure access between the services involved. **[Permissions]**

## ☁️ AWS Architecture

### Architecture Diagram

## &rarr; Final Result

docker build -t 2048-game .
docker tag 2048-game:latest 421613839447.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 421613839447.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo
docker push 421613839447.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest