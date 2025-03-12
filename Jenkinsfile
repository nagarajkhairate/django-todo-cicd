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
                // Checkout the repository from the specified branch
                git branch: 'develop', url: 'https://github.com/nagarajkhairate/django-todo-cicd.git'
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
                    sh 'docker run -d -p 8000:8000 --name django-todo-app ${DOCKER_IMAGE}:${DOCKER_TAG}'
                    
                    // Wait for the container to start up fully (this is optional but a good practice)
                    sh 'sleep 10' // Adjust sleep time if needed based on container startup time
                }
            }
        }

        stage('Apply Migrations') {
            steps {
                script {
                    // Run Django migrations inside the container
                    sh '''
                    CONTAINER_ID=$(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}")
                    if [ -n "$CONTAINER_ID" ]; then
                        docker exec $CONTAINER_ID python manage.py migrate
                    else
                        echo "Error: Docker container is not running!"
                        exit 1
                    fi
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run Django tests inside the container
                    sh '''
                    CONTAINER_ID=$(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}")
                    if [ -n "$CONTAINER_ID" ]; then
                        docker exec $CONTAINER_ID python manage.py test
                    else
                        echo "Error: Docker container is not running!"
                        exit 1
                    fi
                    '''
                }
            }
        }

        stage('Create Superuser') {
            steps {
                script {
                    // Optionally create a Django superuser inside the container
                    sh '''
                    CONTAINER_ID=$(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}")
                    if [ -n "$CONTAINER_ID" ]; then
                        docker exec -it $CONTAINER_ID python manage.py createsuperuser --noinput
                    else
                        echo "Error: Docker container is not running!"
                        exit 1
                    fi
                    '''
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
            // Clean up Docker containers if any exist
            sh '''
            CONTAINERS=$(docker ps -q -f "ancestor=${DOCKER_IMAGE}:${DOCKER_TAG}")
            if [ -n "$CONTAINERS" ]; then
                docker rm -f $CONTAINERS
            fi
            '''
            // Clean up Docker images
            sh '''
            IMAGES=$(docker images -q ${DOCKER_IMAGE}:${DOCKER_TAG})
            if [ -n "$IMAGES" ]; then
                docker rmi -f $IMAGES
            fi
            '''
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
