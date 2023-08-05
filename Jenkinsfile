pipeline {
    agent any 

    tools {
        // Define tool name and version
        maven 'Maven3'
        jdk 'JDK8'
    }

    stages {
        stage('Checkout') {
            steps {
                // C from the SCM
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Build the code using Maven
                sh 'ls'
            }
        }

        stage('Archive') {
            steps {
                // Archive the build artifacts
                sh 'ls'
            }
        }

        stage('Test') {
            steps {
                // Run the unit tests
                sh 'ls'
            }
        }
    }

    post {
        always {
            // Cleanup a
            deleteDir()
        }
        success {
            echo 'Build '
        }
        failure {
            echo 'Blded!'
        }
    }
}
