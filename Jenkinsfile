pipeline {
  agent any
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws_access_key')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_key')
    AWS_DEFAULT_REGION = "eu-west-3"
    AWS_ACCOUNT_ID = '058264315018'
    
    ECR_BACKEND_NAME = 'nti-backend-image'
    ECR_FRONTEND_NAME = 'nti-frontend-image'
    IMAGE_TAG = "${BUILD_NUMBER}"
    BACKEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_BACKEND_NAME}"
    FRONTEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/${ECR_FRONTEND_NAME}"
  }
  stages {
    stage('Start The Pipeline') {
      steps {
        sh 'echo Welcome To NTI Final Project DevOps Automation Track'
        sh "aws ecr get-login-password --region ${env.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
      }
    }
    stage('Build Image and Generate Security Report using Trivy') {
      steps {
        script {
          dir('backend') {
            sh "docker build -t ${env.BACKEND_REPO_URL}:${env.IMAGE_TAG} ."
            // sh "trivy image ${env.BACKEND_REPO_URL}:${env.IMAGE_TAG} > backend_scan.txt"
            // sh "aws s3 cp backend_scan.txt s3://fp-statefile-bucket/"
            sh "docker push ${env.BACKEND_REPO_URL}:${env.IMAGE_TAG}" 
          }
          dir('frontend') {
            sh "docker build -t ${env.FRONTEND_REPO_URL}:${env.IMAGE_TAG} ."
            // sh "trivy image ${env.FRONTEND_REPO_URL}:${env.IMAGE_TAG} > frontend_scan.txt"
            // sh "aws s3 cp frontend_scan.txt s3://fp-statefile-bucket/"
            sh "docker push ${env.FRONTEND_REPO_URL}:${env.IMAGE_TAG}" 
          }
        }
      }
    }
    stage('Update Deployment File') {
      environment {
        GIT_USER_NAME = "samiselim"
      }
      steps {
          sh "sed -i 's|backend-image:latest|${env.BACKEND_REPO_URL}:${env.BUILD_NUMBER}|g' ./k8s/backend_deployment.yaml"
          sh "sed -i 's|frontend-image:latest|${env.FRONTEND_REPO_URL}:$BUILD_NUMBER|g' ./k8s/frontend_deployment.yaml"
          // sh "kubectl apply -f k8s/frontend_deployment.yaml"
      }
    }
  }
}
