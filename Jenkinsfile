pipeline {
    agent any

    environment {
        GIT_CREDENTIALS_ID = '285c1afd-abfb-4f4e-a55a-6dbb10b9ed65'
        SSH_CREDENTIALS_ID = 'terraform-ssh'
        REPO_URL = 'https://github.com/sebbastianG/sciitdevops.git'
        VM_USER = 'jenkins'
        VM_HOST = '192.168.1.12'

        CLOUD_USER = 'sebastian'
        CLOUD_PASS = 'Sebastian123456^%$#@!'
        AWS_VM_IP = '<IP_VM_AWS>'     // ← înlocuiește cu IP real
        AZURE_VM_IP = '<IP_VM_AZURE>' // ← înlocuiește cu IP real
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

        /*
        stage('Enroll Cloud Workers to K3s') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Getting K3s join token from master..."
                    NODE_TOKEN=$(ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST "sudo cat /var/lib/rancher/k3s/server/node-token")

                    echo "Installing sshpass if not present..."
                    which sshpass || (sudo apt-get update && sudo apt-get install -y sshpass)

                    echo "Joining AWS Worker Node..."
                    sshpass -p "$CLOUD_PASS" ssh -o StrictHostKeyChecking=no $CLOUD_USER@$AWS_VM_IP <<EOF
                    sudo apt update
                    sudo apt install -y curl
                    curl -sfL https://get.k3s.io | K3S_URL=https://$VM_HOST:6443 K3S_TOKEN=$NODE_TOKEN sh -
EOF

                    echo "Joining Azure Worker Node..."
                    sshpass -p "$CLOUD_PASS" ssh -o StrictHostKeyChecking=no $CLOUD_USER@$AZURE_VM_IP <<EOF
                    sudo apt update
                    sudo apt install -y curl
                    curl -sfL https://get.k3s.io | K3S_URL=https://$VM_HOST:6443 K3S_TOKEN=$NODE_TOKEN sh -
EOF
                    '''
                }
            }
        }
        */

        stage('Install Prometheus and Grafana') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: SSH_CREDENTIALS_ID, keyFileVariable: 'SSH_KEY')]) {
                    sh '''
                    echo "Deploying Prometheus and Grafana on K3s cluster..."
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY $VM_USER@$VM_HOST <<EOF

                    echo "Creating monitoring namespace if not exists..."
                    kubectl get ns monitoring || kubectl create namespace monitoring

                    echo "Applying Prometheus and Grafana manifests..."
                    kubectl apply -f ~/git-repo/sciitdevops/kubernetes/monitoring/

                    echo "Monitoring stack deployment initiated."
                    exit 0
                    EOF
                    '''
                }
            }
        }
    }
}
