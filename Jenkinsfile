pipeline {
    agent any 


    stages {
         stage('SonarQube analysis') {
            agent {
                docker {
                  image 'sonarsource/sonar-scanner-cli:4.7.0'
                }
               }
               environment {
        CI = 'true'
        //  scannerHome = tool 'Sonar'
        scannerHome='/opt/sonar-scanner'
    }
            steps{
                withSonarQubeEnv('Sonar') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }


        stage('Build') {
            steps {
                // Build the code using Maven
                sh 'ls'
            }
        }




    post {
        always {
            // Cleanup a
            deleteDir()
        }
        success {
            echo 'Budgfgbnmhmhjld '
        } 
        failure {
            echo 'Blded!'
        }
    }
}
