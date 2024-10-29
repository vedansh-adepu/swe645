pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                sh 'git clone https://github.com/vedansh-adepu/swe645.git'
                sh 'cd swe645'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                    sh "docker build -t vedanshadepu99/studentsurvey:latest -f Dockerfile ."
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
