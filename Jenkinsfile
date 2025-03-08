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
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Checking SSH key..."
                    ls -lah $SSH_KEY
                    
                    echo "Testing SSH Connection..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 "echo SSH connected"

                    echo "Executing Terraform on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << EOF
                    cd ~/git-repo/sciitdevops/terraform
                    /snap/bin/terraform init
                    /snap/bin/terraform apply -auto-approve
                    EOF
                    '''
                }
            }
        }
        stage('Ansible Configuration') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << EOF
                    ansible-playbook -i ~/git-repo/sciitdevops/inventory ~/git-repo/sciitdevops/ansible/setup.yml
                    EOF
                    '''
                }
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
