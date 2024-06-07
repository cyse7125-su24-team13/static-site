pipeline {
    agent any
    environment {
        // Define environment variables
        DOCKER_REPO = 'rahhul1309/static-site'
        REGISTRY_CREDENTIALS_ID = 'docker-hub-credentials'
        GIT_REPO = 'https://github.com/cyse7125-su24-team13/static-site.git'
        BRANCH = 'main'
    }
    stages {
        stage('Pre-Cleanup') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout Code') {
            steps {
                git branch: BRANCH, url: GIT_REPO
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('', REGISTRY_CREDENTIALS_ID) {
                        // This block ensures we log into Docker Hub using the credentials stored in Jenkins
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Enabling Docker experimental features for buildx
                    sh "export DOCKER_CLI_EXPERIMENTAL=enabled"
                    // Setup buildx
                    sh "docker buildx create --use --name mybuilder"
                    sh "docker buildx inspect --bootstrap"
                    // Build and push
                    sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${DOCKER_REPO}:${BUILD_NUMBER} . --push"
                }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    // Clean up buildx builder
                    sh "docker buildx rm mybuilder"
                }
            }
        }
    }
    post {
        always {
            // Logout from Docker Hub to ensure we clean up session tokens
            sh "docker logout"
        }
    }
}
