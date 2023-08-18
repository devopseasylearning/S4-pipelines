pipeline {
    agent any 
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
        timeout (time: 60, unit: 'MINUTES')
        timestamps()
      }
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds') 
    }


    stages {





        stage('Build binaries') {

            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
            }
        }


        stage('Build executable') {

            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
            }
        }



        stage('static test') {

            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
            }
        }


        stage('unit test') {

            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
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




        stage('Docker Login') {
            steps {
                script {
                    
                    sh '''
                        echo "${DOCKERHUB_CREDS_PSW}" | docker login --username "${DOCKERHUB_CREDS_USR}" --password-stdin
                    '''
                }
            }
        }



        stage('Build client') {

            steps {
                script {
                    
                    sh '''
                       
                        docker build -t devopseasylearning/kfc:v1.0.${BUILD_NUMBER} .
                        
                    '''
                }
            }
        }



        stage('push client ') {

            steps {
                script {
                    
                    sh '''
                       
                        docker push devopseasylearning/kfc:${BUILD_NUMBER} 
                        
                    '''
                }
            }
        }



        stage('Build api') {

            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
            }
        }


        stage('push api ') {

            steps {
                script {
                    
                    sh '''
                        
                        sleep 10
                      
                    '''
                }
            }
        }

        stage('Build database') {
 
            steps {
                script {
                    
                    sh '''
                     sleep 10
                    '''
                }
            }
        }



        stage('push database ') {
    
            steps {
                script {
                    
                    sh '''
                        sleep 10
                      
                    '''
                }
            }
        }



        stage('End to End test ') {

            steps {
                script {
                    
                    sh '''
                      sleep
                    '''
                }
            }
        }

   stage('Update KFC-app  charts') {

            steps {
                script {

                    sh '''
rm -rf S4-projects-charts || true
git clone git@github.com:devopseasylearning/S4-projects-charts.git
cd S4-projects-charts
ls
pwd
cat << EOF > KFC-app/kfc-charts/dev-values.yaml
image:
  repository: devopseasylearning/kfc
  tag: v1.0.${BUILD_NUMBER}
EOF


git config --global user.name "devopseasylearning"
git config --global user.email "info@devopseasylearning.com"

git add -A 
git commit -m "change from jenkins CI"
git push 
                    '''
                }
            }
        }





        stage('Launch/deploy application ') {

            steps {
                script {
                    
                    sh '''
                      sleep 200
                    '''
                }
            }
        }

    }

   post {
   
   success {
      slackSend (channel: '#development-alerts', color: 'good', message: "SUCCESSFUL: Application KFC  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

 
    unstable {
      slackSend (channel: '#development-alerts', color: 'warning', message: "UNSTABLE: Application KFC  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

    failure {
      slackSend (channel: '#development-alerts', color: '#FF0000', message: "FAILURE: Application KFC Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
   
    cleanup {
      deleteDir()
    }
}


}


