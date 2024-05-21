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
  }
  stages {
    stage('Start The pipeline') {
      steps {
        sh "echo Welcome To NTI Final Project | DevOps & Automation Track"
      }
    }
    stage('Static Code Analysis using sonarQube') {
      environment {
        SONAR_URL = "http://15.237.219.125:9000/"
      }
      steps {
        withCredentials([string(credentialsId: 'sonar_cred', variable: 'SONAR_AUTH_TOKEN')]) {
          sh 'cd backend && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
          sh 'cd frontend && mvn sonar:sonar -Dsonar.login=$SONAR_AUTH_TOKEN -Dsonar.host.url=${SONAR_URL}'
        }
      }
    }
    stage('Build Image and Genereta Security Report using Trivy') {
      environment {
        AWS_ACCOUNT_ID ='058264315018'
        AWS_REGION='eu-west-3'
        ECR_BACKEND_NAME='nti-backend-image'
        ECR_FRONTEND_NAME='nti-frontend-image'
        IMAGE_TAG="${BUILD_NUMBER}"
        BACKEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_BACKEND_NAME}"
        FRONTEND_REPO_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_FRONTEND_NAME}"

      }
      steps {
        script {
            dir('backend'){
                sh "docker build -t ${BACKEND_REPO_URL}:${IMAGE_TAG}"
                sh "trivy image ${BACKEND_REPO_URL}:${IMAGE_TAG} > backend_scan.txt "
            }
            dir('frontend'){
                sh "docker build -t ${FRONTEND_REPO_URL}:${IMAGE_TAG}"
                sh "trivy image ${FRONTEND_REPO_URL}:${IMAGE_TAG} > frontend_scan.txt "
            }
        }
      }
    }
    // stage('Update Deployment File') {
    //     environment {
    //         GIT_REPO_NAME = "argoCd"
    //         GIT_USER_NAME = "samiselim"
    //     }
    //     steps {
    //         withCredentials([string(credentialsId: 'github_tocken', variable: 'GITHUB_TOKEN')]) {
    //             sh '''
    //                 git config user.email "jenkins@gmail.com"
    //                 git config user.name "jenkins"
    //                 BUILD_NUMBER=${BUILD_NUMBER}
    //                 sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml

    //                 git remote set-url origin https://samiselim:${GITHUB_TOKEN}@github.com/samiselim/argoCd.git
    //                 git pull origin main
    //                 git add .
    //                 git commit -m "Update deployment image to version ${BUILD_NUMBER}"
    //                 git push origin HEAD:main
    //             '''
    //         }
    //     }
    // }
  }
}
