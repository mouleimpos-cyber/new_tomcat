pipeline {
    agent any

    tools {
        maven 'maven_2025'
    }

    environment {
		DOCKERHUB_CREDENTIALS = credentials('docker_pre')
	
        DOCKER_HUB_REPO = 'chandramoule97/myasus'
        IMAGE_TAG = "v12.2"
        IMAGE_LOCAL = "myasus:${IMAGE_TAG}"
        IMAGE_REMOTE = "${DOCKER_HUB_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github_pre', url: 'https://github.com/mouleimpos-cyber/new_tomcat.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn -B clean package'
            }
        }

        stage('Check Docker') {
            steps {
                sh '''
                  if ! command -v docker >/dev/null 2>&1; then
                    echo "Docker not found on this node. Ensure agent has Docker installed."
                    exit 1
                  fi
                  docker --version || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_LOCAL} ."
            }
        }

        stage('Login, Tag & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker_pre', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                      echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                      docker tag ${IMAGE_LOCAL} ${IMAGE_REMOTE}
                      docker push ${IMAGE_REMOTE}
                    '''
                }
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                    docker stop myasus || true
                    docker rm myasus || true
                    docker run -d --name myasus -p 8081:8080 ${IMAGE_REMOTE}
                '''
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
        failure {
            echo 'Pipeline failed — check the console output for the failing stage and error messages.'
        }
    }
}
 
