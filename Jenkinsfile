pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Check out the code from a Git repository
                git 'https://github.com/yourusername/your-repo.git'
            }
        }
        
        stage('Build') {
            steps {
                // Build the Maven project
                sh 'mvn clean install'
               
            }
        }
        
        
        stage('Test') {
            steps {
                // Run tests
                sh 'mvn test'
                
            }
        }
    }
    
    post {
        always {
            // Clean up after the build, regardless of success or failure
            deleteDir()
        }
        success {
            // Actions to perform if the build is successful
            echo 'Build successful!'
        }
        failure {
            // Actions to perform if the build fails
            echo 'Build failed!'
        }
    }
}
