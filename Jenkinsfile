pipeline {
    agent any
    environment {
        // Define environment variables
        DOCKER_REPO = 'rahhul1309/static-site'
        REGISTRY_CREDENTIALS_ID = 'docker-hub-credentials'
        GIT_REPO = 'https://github.com/cyse7125-su24-team13/static-site.git'
        BRANCH = 'main'
    }
    options {
        credentialsBinding {
            usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')
        }
    }
    stages {
        stage('Checkout Code') {
            steps {
                git branch: BRANCH, credentialsId: 'github-token', url: GIT_REPO
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
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
