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
                script {
                    // Properly using credentials to checkout code
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: BRANCH]],
                        userRemoteConfigs: [[
                            url: GIT_REPO,
                            credentialsId: 'github-token'
                        ]]
                    ])
                }
            }
        }
        stage('Login to Docker Hub') {
            steps {
                script {
                    // Using credentials to login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    }
                }
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Assuming Docker and Docker Buildx are configured on the Jenkins agent
                    sh "export DOCKER_CLI_EXPERIMENTAL=enabled"
                    sh "docker buildx create --use --name mybuilder"
                    sh "docker buildx inspect --bootstrap"
                    sh "docker buildx build --platform linux/amd64,linux/arm64 -t ${env.DOCKER_REPO}:${env.BUILD_NUMBER} . --push"
                }
            }
        }
        stage('Cleanup') {
            steps {
                script {
                    sh "docker buildx rm mybuilder"
                }
            }
        }
    }
    post {
        always {
            // Logout from Docker Hub to ensure session tokens are cleaned up
            sh "docker logout"
        }
    }
}
