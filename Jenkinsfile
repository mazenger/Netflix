pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        REMOTE_HOST = 'your-remote-host'
        REMOTE_USER = 'your-remote-user'
        REMOTE_KEY = 'your-ssh-key-path'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mazenger/Netflix.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("mazaconda/netflix-app:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'DOCKERHUB_CREDENTIALS') {
                        docker.image("mazaconda/netflix-app:latest").push()
                    }
                }
            }
        }

        stage('Deploy to Remote Host') {
            steps {
                sshagent (credentials: ['your-ssh-credentials-id']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} << EOF
                    docker pull mazaconda/netflix-app:latest
                    docker stop netflix-app-container || true
                    docker rm netflix-app-container || true
                    docker run -d --name netflix-app-container -p 3000:3000 mazaconda/netflix-app:latest
                    sleep 10
                    docker logs netflix-app-container
                    EOF
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sshagent (credentials: ['your-ssh-credentials-id']) {
                    script {
                        def appRunning = sh(
                            script: """
                            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} << EOF
                            curl -s -o /dev/null -w "%{http_code}" http://localhost:3000
                            EOF
                            """,
                            returnStdout: true
                        ).trim()
                        if (appRunning != '200') {
                            error("Application is not running or failed to start.")
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
