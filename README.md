
# NTI Final Project DevOps Automation Track

## Project Overview

This project automates the build, security scan, and deployment of backend and frontend Docker images using Jenkins, AWS ECR, Trivy, and ArgoCD. The pipeline consists of multiple stages that handle different aspects of the CI/CD process, ensuring that the applications are built, scanned for vulnerabilities, and deployed seamlessly.

## Prerequisites

- Jenkins (installed using Ansible)
- AWS CLI
- Docker
- Trivy
- AWS ECR Repositories
- AWS S3 Bucket
- GitHub Repository
- ArgoCD
- AWS CloudWatch Agent (installed on all nodes)
- AWS Backup Service (configured for daily snapshots of Jenkins instance)

## Pipeline Configuration

The Jenkins pipeline is defined inside Jenkinsfile in this Repo 

## Steps to Set Up the Project

1. **Install Jenkins**: Set up Jenkins on your preferred platform using Ansible.
2. **Configure AWS CLI**: Ensure that AWS CLI is installed and configured with necessary permissions.
3. **Set Up Docker and Trivy**: Install Docker and Trivy on the Jenkins server.
4. **Create ECR Repositories**: Create ECR repositories for the backend and frontend images.
5. **Set Up AWS S3 Bucket**: Create an S3 bucket to store security scan reports.
6. **Configure Jenkins Credentials**:
   - AWS credentials (`aws_access_key` and `aws_secret_key`)
   - GitHub token (`github_tocken`)
7. **Set Up GitHub Repository**: Ensure your codebase is hosted on GitHub.
8. **ArgoCD Setup**: Install ArgoCD and configure it to sync with your GitHub repository.
9. **Install CloudWatch Agent**: Use Ansible to install the CloudWatch agent on all nodes.
10. **Configure AWS Backup**: Set up AWS Backup to take daily snapshots of the Jenkins instance.

## ArgoCD Configuration

After the Jenkins pipeline pushes the updated deployment files to the GitHub repository, ArgoCD will detect the changes and automatically deploy the updated applications.

### Steps to Install ArgoCD Using Operators

1. **Install ArgoCD Operator**: Follow the official documentation to install the ArgoCD operator on your Kubernetes cluster.
2. **Create ArgoCD Instance**: Deploy an ArgoCD instance using the operator.
3. **Configure ArgoCD**:
   - Connect ArgoCD to your GitHub repository.
   - Set up sync policies to automatically apply changes from the repository.

### ArgoCD Sync Configuration

With this setup, any changes pushed by Jenkins to the GitHub repository will be automatically detected and deployed by ArgoCD, ensuring continuous delivery of your applications.

## Conclusion

This project demonstrates a complete CI/CD pipeline using Jenkins, AWS services, and ArgoCD. The automation ensures that your backend and frontend applications are built, scanned for security vulnerabilities, and deployed efficiently, providing a robust DevOps workflow.

Feel free to contribute and make improvements to this project. Happy DevOps!
