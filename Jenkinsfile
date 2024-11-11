pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    triggers {
        pollSCM('* * * * *') // Or you can remove this if you want only webhook-based triggers
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
                git url: 'https://github.com/vedansh-adepu/swe645.git', credentialsId: 'e0b50d84-9471-4900-9b5d-c6aa2c095f3b'
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

