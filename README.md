# CICD 2048 Game

## 🌟 Overview
This project focuses on setting up a CI/CD pipeline for deploying a Dockerized version of the 2048 game to AWS. The pipeline automates the process of building, testing, and deploying the game to a scalable infrastructure using Amazon ECS, Amazon ECR, and AWS CodePipeline.

## 🛠️ Services used
* **AWS CodePipeline**: Orchestrates the CI/CD pipeline, automating the build, test, and deployment stages. **[Automation]**
* **Amazon ECS**: Deploys and manages containerized applications using Fargate for serverless container management. **[Deployment]**
* **Amazon ECR**: Stores and manages Docker images used in the ECS tasks. **[Container Registry]** 
* **AWS CodeBuild**: Handles the build phase of the pipeline, including Docker image creation. **[Build]**
* **AWS S3**: Handles storing the the build artifact **[Storage]**
* **IAM Roles & Policies**: Ensure secure access between the services involved. **[Permissions]**

## 🛠️ Setup
### Build docker image
#### Targets x86_64 Architecture if running on mac with Apple M4 Chip
```docker buildx build --platform linux/amd64 -t 2048-game .```
#### Otherwise
```docker build -t 2048-game .```
#### Create private Amazon ECR to store image
![alt text](design/create-ecr-repo.png)
![alt text](design/successful-create-ecr-repo.png)
#### Tag image in preparation to push to Amazon ECR
```docker tag 2048-game:latest <AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest```
#### Retrieves a temporary authorization token used to authenticate a container client (like Docker) to an Amazon ECR registry.
```aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest```
#### Push image to private Amazon ECR
![alt text](design/push-image-to-ecr.png)
![alt text](design/image-ecr-success.png)

#### Create ECS Cluster
![alt text](design/create-cluster.png)
#### Confirm the AWSServiceRoleForECS role was created after the cluster is created
![alt text](design/awsServiceRoleForECS-role.png)
#### Register a Task Definition
![alt text](design/create-task.png)
![alt text](design/task-def-container.png)
#### Configure the service
![alt text](design/service.png)
#### Make sure to add a security group to allow HTTP request on port 80
![alt text](design/networking.png)
#### Deploy service
![alt text](design/service-deploying.png)
![alt text](design/configure-after-deployment.png)
#### Open browser and enter in public ip address
![alt text](design/website.png)
### Setup CI/CD
#### Configure buildspec.yml
```
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo
  build:
    commands:
      - echo Building the Docker image...
      - docker buildx build --platform linux/amd64 -t 2048-game .
      - echo Tagging the Docker image...
      - docker tag 2048-game:latest <AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest
  post_build:
    commands:
      - echo Pushing the Docker image to Amazon ECR...
      - docker push <AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest
      - echo Creating imagedefinitions.json file for ECS deployment...
      - echo '[{"name":"2048-container","imageUri":"<AWS_ACCOUNT#>.dkr.ecr.us-east-1.amazonaws.com/2048-game-repo:latest"}]' > imagedefinitions.json
artifacts:
  files:
    - imagedefinitions.json
```
#### Create Code Build Role
* AmazonEC2ContainerRegistryFullAccess: Allows CodeBuild to interact with ECR (Elastic Container Registry).
* AWSCodeBuildDeveloperAccess: Grants permissions for CodeBuild to access build-related resources.
* AmazonS3FullAccess: Grants access to read/write to S3 buckets (for storing build artifacts).
* ECSAccessPolicy: Inline Policy to allow CodeBuild to update ECS services:

![alt text](design/ECSAccessPolicy.png)
![alt text](design/codebuild-role.png)

#### Create S3 bucket
![alt text](design/s3-bucket.png)
#### Create CodeBuild project
![alt text](design/create-code-build-project.png)
#### Setting up environment in CodeBuild project
![alt text](design/configure-environment.png)
#### Setting up artifact in CodeBuild project
![alt text](design/artifact-s3.png)
#### Build results from CodeBuild
![alt text](design/build-results.png)

#### Create pipeline and review the settings
![alt text](design/pipeline-review-1.png)
![alt text](design/pipeline-review-2.png)
#### Pipeline running
![alt text](design/pipeline-running.png)
#### Pipeline complete
![alt text](design/pipeline-complete.png)

## ☁️ AWS Architecture


## &rarr; Final Result
![alt text](design/task-configuration.png)
![alt text](design/website-pre-deployment.png)

![alt text](design/before-push.png)
![alt text](design/after-push.png)