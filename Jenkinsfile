pipeline {
  agent {
    docker {
      image 'samiselim/ubuntu:v2.0'
      args '--user root -v /var/run/docker.sock:/var/run/docker.sock' 
    }
  }
    environment{
    AWS_ACCESS_KEY_ID = credentials('aws_access_key')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
    AWS_DEFAULT_REGION = "eu-west-3"
    AWS_ACCOUNT_ID ='058264315018'
    
    ECR_BACKEND_NAME='nti-backend-image'
    ECR_FRONTEND_NAME='nti-frontend-image'
    IMAGE_TAG="${BUILD_NUMBER}"
    BACKEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_BACKEND_NAME}"
    FRONTEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_FRONTEND_NAME}"
  }
  stages {
    stage('Start The pipeline') {
      steps {
        sh "echo Welcome To NTI Final Project DevOps Automation Track"
      }
    }
    stage('Build Image and Genereta Security Report using Trivy') {
      steps {
        script {
            dir('backend'){
                sh "docker build -t ${BACKEND_REPO_URL}:${IMAGE_TAG} ."
                sh "trivy image ${BACKEND_REPO_URL}:${IMAGE_TAG} > backend_scan.txt "
                sh "aws s3 cp backend_scan.txt  s3://fp-statefile-bucket/"
            }
            dir('frontend'){
                sh "docker build -t ${FRONTEND_REPO_URL}:${IMAGE_TAG} ."
                sh "trivy image ${FRONTEND_REPO_URL}:${IMAGE_TAG} > frontend_scan.txt "
                sh "aws s3 cp frontend_scan.txt  s3://fp-statefile-bucket/"
            }
        }
      }
    }
    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "argoCd"
            GIT_USER_NAME = "samiselim"
        }
        steps {
            withCredentials([string(credentialsId: 'github_tocken', variable: 'GITHUB_TOKEN')]) {
                
              sh "git config user.email jenkins@gmail.com"
              sh "git config user.name jenkins"
              sh "BUILD_NUMBER=${BUILD_NUMBER}"
              sh "sed -i 's|backend-image:latest|${BACKEND_REPO_URL}:${IMAGE_TAG}|g' k8s/backend-deployment.yaml"
              sh "sed -i 's|frontend-image:latest|${FRONTEND_REPO_URL}:${IMAGE_TAG}|g' k8s/frontend-deployment.yaml"


              sh "git remote set-url origin https://samiselim:${GITHUB_TOKEN}@github.com/samiselim/FinalProject_NTI.git"
              sh "git pull origin main"
              sh "git add ."
              sh "git commit -m "Update deployment image to version ${BUILD_NUMBER}""
              sh "git push origin HEAD:main"
            }
        }
    }
  }
}
