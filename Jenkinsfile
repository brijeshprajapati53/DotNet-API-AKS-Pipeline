pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal'
        ACR_NAME = "acrbrijesh123"
        ACR_LOGIN_SERVER = "acrbrijesh123.azurecr.io"
        IMAGE_NAME = "mywebapi"
        TAG = "latest"
        RESOURCE_GROUP = "my-rg"
        AKS_CLUSTER_NAME = "aksclusterbrijesh123"
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/brijeshprajapati53/DotNet-API-AKS-Pipeline.git' // replace with your actual repo
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('Terraform') {
                    bat 'terraform init'
                    bat 'terraform apply -auto-approve'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                bat """
                    az acr login --name %ACR_NAME%
                    docker build -t %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%TAG% .
                    docker push %ACR_LOGIN_SERVER%/%IMAGE_NAME%:%TAG%
                """
            }
        }

stage('Push Docker Image to ACR') {
      steps {
        bat 'az acr login --name %ACR_NAME%'
        bat 'docker push %ACR_NAME%.azurecr.io/%IMAGE_NAME%:latest'
      }
    }


        stage('AKS Authentication') {
            steps {
                bat """
                    az aks get-credentials --resource-group %RESOURCE_GROUP% --name %AKS_CLUSTER_NAME% --overwrite-existing
                """
            }
        }

        stage('Deploy to AKS') {
            steps {
                bat 'kubectl apply -f deployment.yaml'
                bat 'kubectl apply -f service.yaml'
            }
        }
    }

    post {
        failure {
            echo "❌ Build failed."
        }
        success {
            echo "✅ Application deployed successfully to AKS!"
        }
    }
}
