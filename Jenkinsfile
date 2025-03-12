pipeline {
    agent any

    environment {
        // Define environment variables for Docker image
        DOCKER_IMAGE = 'django-todo-app'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository
                git 'https://github.com/nagarajkhairate/django-todo-cicd.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using the Dockerfile
                    sh 'docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container and expose the appropriate port
                    sh 'docker run -d -p 8000:8000 ${DOCKER_IMAGE}:${DOCKER_TAG}'
                }
            }
        }

        stage('Apply Migrations') {
            steps {
                script {
                    // Run Django migrations inside the container
                    sh 'docker exec $(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}") python manage.py migrate'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run Django tests inside the container
                    sh 'docker exec $(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}") python manage.py test'
                }
            }
        }

        stage('Create Superuser') {
            steps {
                script {
                    // Optionally create a Django superuser inside the container
                    sh 'docker exec -it $(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}") python manage.py createsuperuser --noinput'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Deploy to the desired environment (example: deploy to AWS, Heroku, or other server)
                    echo "Deploying application..."
                    // For example, deploy using Docker or any other deployment step you prefer
                }
            }
        }
    }

    post {
        always {
            // Clean up Docker containers after the job is done
            sh 'docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}" | xargs docker rm -f'
            sh 'docker images -q ${DOCKER_IMAGE}:${DOCKER_TAG} | xargs docker rmi -f'
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
