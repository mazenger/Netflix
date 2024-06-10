pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'mazaconda/netflix-app'
        DOCKER_IMAGE_TAG = 'latest' 
        CONTAINER_NAME = 'netflix-app-container'
        REPO_URL = 'https://github.com/mazenger/Netflix.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: "${env.REPO_URL}"
            }
        }

        stage('Pull Docker Image') {
            steps {
                script {
                    sh "docker pull ${env.DOCKER_HUB_REPO}:${env.DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d --name ${env.CONTAINER_NAME} -p 3000:3000 ${env.DOCKER_HUB_REPO}:${env.DOCKER_IMAGE_TAG}"
                }
            }
        }

        stage('Access Application') {
            steps {
                script {
                    sleep 10
                    
                    sh "curl http://localhost:3000"
                }
            }
        }
    }


}
