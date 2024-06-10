pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'mazaconda/netflix-app'
        DOCKER_IMAGE_TAG = 'latest' 
        CONTAINER_NAME = 'netflix-app-container'
        REPO_URL = 'https://github.com/mazenger/Netflix.git'
        BRANCH_NAME = 'main' // Specify the branch name
        REMOTE_HOST = '18.171.149.13'
        SSH_CREDENTIALS_ID = 'ec2-user' // The ID of the SSH credentials in Jenkins
        REMOTE_USER = 'ec2-user' // The username for your remote host
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${env.REPO_URL}", branch: "${env.BRANCH_NAME}"
            }
        }

        stage('Pull Docker Image on Remote Host') {
            steps {
                script {
                    sshagent (credentials: ["${env.SSH_CREDENTIALS_ID}"]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} 'docker pull ${env.DOCKER_HUB_REPO}:${env.DOCKER_IMAGE_TAG}'
                        """
                    }
                }
            }
        }

        stage('Run Docker Container on Remote Host') {
            steps {
                script {
                    sshagent (credentials: ["${env.SSH_CREDENTIALS_ID}"]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} 'docker run -d --name ${env.CONTAINER_NAME} -p 3000:3000 ${env.DOCKER_HUB_REPO}:${env.DOCKER_IMAGE_TAG}'
                        """
                    }
                }
            }
        }

        stage('Access Application') {
            steps {
                script {
                    sleep 10
                    sshagent (credentials: ["${env.SSH_CREDENTIALS_ID}"]) {
                        sh """
                        ssh -o StrictHostKeyChecking=no ${env.REMOTE_USER}@${env.REMOTE_HOST} 'curl http://localhost:3000'
                        """
                    }
                }
            }
        }
    }
}
