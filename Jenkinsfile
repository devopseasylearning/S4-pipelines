pipeline {
    agent any 
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        timeout (time: 60, unit: 'MINUTES')
        timestamps()
      }

    stages {

       stage('Builddddd') {
            steps {
                // Build the code using Maven
                sh '''
                ls 
                cat sonar-project.properties 
                '''
            }
        }





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


}
}