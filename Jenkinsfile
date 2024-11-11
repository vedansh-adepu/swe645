pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('* * * * *')
    }

    environment {
        IMAGE_TAG = "${env.BUILD_NUMBER}"  // Only the build number
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                checkout scm // Use Jenkins SCM tracking
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker build -t vedanshadepu99/studentsurvey:${IMAGE_TAG} -f Dockerfile ." // Use . for current directory
                    sh "docker push vedanshadepu99/studentsurvey:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Replace IMAGE_TAG placeholder in the deployment file with the current build number
                sh "sed -i 's|IMAGE_TAG|${IMAGE_TAG}|g' studentsurvey-deployment.yaml"
                
                // Apply the updated YAML file
                sh "kubectl apply -f studentsurvey-deployment.yaml"
                sh "kubectl apply -f studentsurvey-service.yaml"
            }
        }
    }
}
