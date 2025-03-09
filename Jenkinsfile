pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = '285c1afd-abfb-4f4e-a55a-6dbb10b9ed65'
        SSH_CREDENTIALS_ID = 'terraform-ssh'
        REPO_URL = 'https://github.com/sebbastianG/sciitdevops.git'
        VM_USER = 'jenkins'
        VM_HOST = '192.168.1.12'
    }

    stages {
        stage('Clone Repository on VM') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Testing SSH Connection..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST "echo SSH connected"

                    echo "Cloning repository on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST <<EOF
                    mkdir -p ~/git-repo
                    cd ~/git-repo
                    if [ ! -d "sciitdevops" ]; then
                        git clone $REPO_URL
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

        stage('Run Terraform') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Running Terraform on VM..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST <<EOF
                    cd ~/git-repo/sciitdevops/terraform || exit 1
                    terraform init
                    terraform apply -auto-approve
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Run Ansible') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Executing Ansible Playbook..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST <<EOF
                    cd ~/git-repo/sciitdevops/ansible
                    if [ -f setup.yml ]; then
                        ansible-playbook -i inventory setup.yml
                    else
                        echo "Ansible Playbook not found! Skipping."
                    fi
                    exit 0
                    EOF
                    '''
                }
            }
        }

        stage('Build and Deploy App') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Building and Deploying App..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST <<EOF
                    cd ~/git-repo/sciitdevops
                    docker build -t my-weather-app:latest .
                    kubectl apply -f kubernetes/deployment.yaml
                    exit 0
                    EOF
                    '''
                }
            }
        }
    }
}
