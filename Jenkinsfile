pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    triggers {
        // Optionally add Poll SCM if the webhook doesn't trigger builds consistently
        pollSCM('H/5 * * * *')
    }

    environment {
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                // Uses Jenkins' SCM management to monitor and check out code
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker build -t vedanshadepu99/studentsurvey:${IMAGE_TAG} -f swe645/Dockerfile swe645"
                    sh "docker push vedanshadepu99/studentsurvey:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                // Replace IMAGE_TAG placeholder in the deployment file with the current build number
                sh "sed -i 's|IMAGE_TAG|${IMAGE_TAG}|g' swe645/studentsurvey-deployment.yaml"
                
                // Apply the updated YAML file
                sh "kubectl apply -f swe645/studentsurvey-deployment.yaml"
                sh "kubectl apply -f swe645/studentsurvey-service.yaml"
            }
        }
    }
}
