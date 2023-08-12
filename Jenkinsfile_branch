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

        stage('Setup parameters') {
            steps {
                script {
                    properties([
                        parameters([
                            choice(
                                choices: ['DEV', 'QA', 'PREPROD'], 
                                name: 'ENVIRONMENT'
                            ),
                        string(
                             defaultValue: '50',
                             name: 'auth_tag',
                             description: '''Please enter auth image tage to be used''',
                            ),

                        string(
                             defaultValue: '50',
                             name: 'db_tag',
                             description: '''Please enter db  image tage to be used''',
                            ),

                        string(
                             defaultValue: '50',
                             name: 'ui_tag',
                             description: '''Please enter ui image tage to be used''',
                            ),

                        string(
                             defaultValue: '50',
                             name: 'weather_tag',
                             description: '''Please enter weather  image tage to be used''',
                            ),


                             string(name: 'WARNTIME',
                             defaultValue: '0',
                            description: '''Warning time (in minutes) before starting upgrade'''),

                        ]),
                            choice(
                                choices: ['APP_NAME'], 
                                name: 'S4-pipeline'
                            ),
                    ])
                }
            }
        }




         stage('SonarQube analysis') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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
                    // Log in to Docker Hub
                    sh '''
                        echo "${DOCKERHUB_CREDS_PSW}" | docker login --username "${DOCKERHUB_CREDS_USR}" --password-stdin
                    '''
                }
            }
        }



        stage('Build auth') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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





        stage('Build db') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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




        stage('Build ui') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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




        stage('Build weather') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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




        }




   post {
   
   success {
      slackSend (channel: '#development-alerts', color: 'good', message: "SUCCESSFUL: Application ${APP_NAME}  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

 
    unstable {
      slackSend (channel: '#development-alerts', color: 'warning', message: "UNSTABLE: Application ${APP_NAME}  Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }

    failure {
      slackSend (channel: '#development-alerts', color: '#FF0000', message: "FAILURE: Application ${APP_NAME} Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
    }
   
    cleanup {
      deleteDir()
    }
}




}
