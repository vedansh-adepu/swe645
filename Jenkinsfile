pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('* * * * *')
    }

    environment {
        IMAGE_TAG = "studentsurvey:${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                sh 'git clone https://github.com/vedansh-adepu/swe645.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker build -t vedanshadepu99/${IMAGE_TAG} -f swe645/Dockerfile swe645"
                    sh "docker push vedanshadepu99/${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Update the image tag in deployment file
                sh "sed -i 's|vedanshadepu99/studentsurvey:.*|vedanshadepu99/${IMAGE_TAG}|g' swe645/studentsurvey-deployment.yaml"
                sh "kubectl apply -f swe645/studentsurvey-deployment.yaml"
                sh "kubectl apply -f swe645/studentsurvey-service.yaml"
            }
        }
    }
}
