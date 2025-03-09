pipeline {
    agent any
    environment {
        GIT_CREDENTIALS_ID = '285c1afd-abfb-4f4e-a55a-6dbb10b9ed65'
    }
    stages {
        stage('Clone Repository on VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Checking SSH key..."
                    ls -lah $SSH_KEY
                    
                    echo "Testing SSH Connection..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 "echo SSH connected"

                    echo "Cloning repository on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    mkdir -p ~/git-repo
                    cd ~/git-repo
                    if [ ! -d "sciitdevops" ]; then
                        git clone https://github.com/sebbastianG/sciitdevops.git
                    else
                        cd sciitdevops
                        git reset --hard
                        git pull origin main
                    fi
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Executing Terraform on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    cd ~/git-repo/sciitdevops/terraform || exit 1
                    terraform init
                    terraform apply -auto-approve
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Ansible Configuration') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    ansible-playbook -i ~/git-repo/sciitdevops/inventory ~/git-repo/sciitdevops/ansible/setup.yml
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Build and Deploy App') {
            steps {
                sh '''
                echo "Building Docker Image..."
                docker build -t my-weather-app:latest .

                echo "Deploying to Kubernetes..."
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
