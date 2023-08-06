pipeline {
    agent any 
    options {
        buildDiscarder(logRotator(numToKeepStr: '20'))
        disableConcurrentBuilds()
        timeout (time: 60, unit: 'MINUTES')
        timestamps()
      }
    environment {
        DOCKERHUB_CREDS = credentials('dockerhub-creds') 
    }

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


        //  stage("Quality Gate") {
        //     steps {
        //       timeout(time: 1, unit: 'HOURS') {
        //         waitForQualityGate abortPipeline: true
        //       }
        //     }
        //  }



        stage('Docker Login') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        echo "${DOCKERHUB_CREDS_PSW}" | docker login --username "${DOCKERHUB_CREDS_USR}" --password-stdin
                    '''
                }
            }
        }



        stage('Build auth') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        cd auth 
                        docker build -t devopseasylearning/s4-pipeline-auth:${BUILD_NUMBER} .
                        cd -
                    '''
                }
            }
        }


        stage('push auth ') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                       
                        docker push devopseasylearning/s4-pipeline-auth:${BUILD_NUMBER} 
                        
                    '''
                }
            }
        }



        stage('Build db') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        cd DB
                        docker build -t devopseasylearning/s4-pipeline-db:${BUILD_NUMBER} .
                        cd -
                    '''
                }
            }
        }


        stage('push db ') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        
                        docker push devopseasylearning/s4-pipeline-db:${BUILD_NUMBER} 
                      
                    '''
                }
            }
        }

        stage('Build ui') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        cd UI
                        docker build -t devopseasylearning/s4-pipeline-ui:${BUILD_NUMBER} .
                        cd -
                    '''
                }
            }
        }


        stage('push ui ') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        docker push devopseasylearning/s4-pipeline-ui:${BUILD_NUMBER}
                      
                    '''
                }
            }
        }

        stage('Build weather') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        cd weather
                        docker build -t devopseasylearning/s4-pipeline-weather:${BUILD_NUMBER} .
                        cd -
                    '''
                }
            }
        }


        stage('push weather ') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        docker push devopseasylearning/s4-pipeline-weather:${BUILD_NUMBER}
                    '''
                }
            }
        }


        stage('Update  charts') {
            steps {
                script {

                    sh '''
git clone git@github.com:devopseasylearning/S4-projects-charts.git
cd S4-projects-charts
ls
pwd
cat << EOF > charts/weatherapp-auth/dev-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-auth
  tag: ${BUILD_NUMBER}
EOF







cat << EOF > charts/weatherapp-mysql/dev-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-db
  tag: ${BUILD_NUMBER}
EOF





cat << EOF > charts/weatherapp-ui/dev-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-ui
  tag: ${BUILD_NUMBER}
EOF






cat << EOF > charts/weatherapp-weather/dev-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-weather
  tag: ${BUILD_NUMBER}
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


}

   post {
   
   success {
      slackSend (channel: '#development-alerts', color: 'good', message: "SUCCESSFUL: Application S4-PIPELINE  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

 
    unstable {
      slackSend (channel: '#development-alerts', color: 'warning', message: "UNSTABLE: Application S4-PIPELINE  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

    failure {
      slackSend (channel: '#development-alerts', color: '#FF0000', message: "FAILURE: Application S4-PIPELINE Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
   
    cleanup {
      deleteDir()
    }
}


}