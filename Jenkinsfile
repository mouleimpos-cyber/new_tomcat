pipeline {
    agent any

    tools {
        maven 'maven_2025'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker_pre')

        DOCKER_HUB_REPO = 'chandramoule97/myasus'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github_pre', url: 'https://github.com/mouleimpos-cyber/new_tomcat.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myasus:v12.2 .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }

        stage('Tag Docker Image') {
            steps {
                sh 'docker tag myasus:v12.2 chandramoule97/myasus:v12.2'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push chandramoule97/myasus:v12.2'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker stop myasus || true
                    docker rm myasus || true
                    docker run -d --name myasus -p 8081:80 chandramoule97/myasus:v12.2
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
