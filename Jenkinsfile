pipeline {
    agent any
    environment {
        GIT_CREDENTIALS_ID = '285c1afd-abfb-4f4e-a55a-6dbb10b9ed65'
    }
    stages {
        stage('Clone Repository') {
            steps {
                git credentialsId: "${GIT_CREDENTIALS_ID}", url: 'https://github.com/sebbastianG/sciitdevops.git', branch: 'main'
            }
        }
        stage('Terraform Init & Apply') {
            steps {
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
        stage('Ansible Configuration') {
            steps {
                sh '''
                ansible-playbook -i inventory ansible/setup.yml
                '''
            }
        }
        stage('Build and Deploy App') {
            steps {
                sh '''
                docker build -t my-weather-app:latest .
                kubectl apply -f kubernetes/deployment.yaml
                '''
            }
        }
        stage('Trigger ArgoCD Sync') {
            steps {
                sh 'argocd app sync my-weather-app'
            }
        }
    }
}
