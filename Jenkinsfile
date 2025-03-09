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

        stage('Fix Terraform Module & Apply') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Fixing Terraform Module Path..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    cd ~/git-repo/sciitdevops/terraform || exit 1

                    echo "Checking Terraform Modules..."
                    if [ ! -d "terraform-modules/tf-s3-modules" ]; then
                        echo "Terraform module directory not found! Exiting."
                        exit 1
                    fi

                    echo "Fixing Terraform Module Source..."
                    sed -i 's|git::https://github.com/mihai-satmarean/sciitdevops/blob/main/terraform/terraform-modules/tf-s3-modules/|../terraform-modules/tf-s3-modules|' s3.tf

                    echo "Initializing Terraform..."
                    rm -rf .terraform
                    terraform init -upgrade
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
                    echo "Executing Ansible Playbook on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    if [ -f ~/git-repo/sciitdevops/ansible/setup.yml ]; then
                        ansible-playbook -i ~/git-repo/sciitdevops/inventory ~/git-repo/sciitdevops/ansible/setup.yml
                    else
                        echo "Ansible playbook not found! Skipping."
                        exit 1
                    fi
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Build and Deploy App') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'terraform-ssh', keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Ensuring Docker is installed..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    if ! command -v docker &> /dev/null; then
                        echo "Docker is missing. Installing..."
                        sudo apt update
                        sudo apt install -y docker.io
                    fi
                    docker --version
                    EOF

                    echo "Building Docker Image..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    cd ~/git-repo/sciitdevops
                    docker build -t my-weather-app:latest .
                    EOF

                    echo "Deploying to Kubernetes..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY jenkins@192.168.1.12 << 'EOF'
                    kubectl apply -f ~/git-repo/sciitdevops/kubernetes/deployment.yaml
                    EOF
                    '''
                }
            }
        }

        stage('Trigger ArgoCD Sync') {
            steps {
                sh '''
                echo "Triggering ArgoCD Sync..."
                argocd app sync my-weather-app
                '''
            }
        }
    }
}
