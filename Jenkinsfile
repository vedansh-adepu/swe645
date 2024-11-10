pipeline {
    agent any

    options {
        // This will delete the workspace before each build, ensuring a clean environment
        skipDefaultCheckout()  // Skip the default checkout since we're manually checking out the code
    }

    triggers {
        // This enables the pipeline to be triggered automatically when changes are pushed to the repository
        pollSCM('* * * * *')  // Adjust the polling frequency as necessary, e.g., every minute
    }

    stages {
        stage('Clean Workspace') {
            steps {
                // Delete workspace before build starts
                cleanWs()
            }
        }

        stage('Checkout Code') {
            steps {
                // Manually clone the repository to the workspace
                sh 'git clone https://github.com/vedansh-adepu/swe645.git'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    // Specify the Dockerfile in the cloned directory
                    sh "docker build -t vedanshadepu99/studentsurvey:latest -f swe645/Dockerfile swe645"
                    sh "docker push vedanshadepu99/studentsurvey:latest"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh "kubectl apply -f swe645/studentsurvey-deployment.yaml"
                sh "kubectl apply -f swe645/studentsurvey-service.yaml"
            }
        }
    }
}

