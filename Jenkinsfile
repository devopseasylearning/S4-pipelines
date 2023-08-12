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

                        string(
                             defaultValue: 'develop',
                             name: 'Please_leave_this_section_as_it_is',
                            ),


                        ]),

                    ])
                }
            }
        }


       stage('warning') {
      steps {
        script {
            notifyUpgrade(currentBuild.currentResult, "WARNING")
            sleep(time:env.WARNTIME, unit:"MINUTES")
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


        stage('push auth ') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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


        stage('push db ') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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


        stage('push ui ') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
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


        stage('push weather ') {
           when{  
            expression {
              env.ENVIRONMENT == 'DEV' }
              }
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        docker push devopseasylearning/s4-pipeline-weather:${BUILD_NUMBER}
                    '''
                }
            }
        }



        stage('QA: pull images ') {
           when{  
            expression {
              env.ENVIRONMENT == 'QA' }
              }
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        docker pull devopseasylearning/s4-pipeline-auth:$auth_tag 
                        docker pull devopseasylearning/s4-pipeline-db:$db_tag 
                        docker pull devopseasylearning/s4-pipeline-ui:$ui_tag 
                        docker pull devopseasylearning/s4-pipeline-weather:$weather_tag 
                    '''
                }
            }
        }


        stage('QA: tag  images ') {
           when{  
            expression {
              env.ENVIRONMENT == 'QA' }
              }
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                        docker tag  devopseasylearning/s4-pipeline-auth:$auth_tag devopseasylearning/s4-pipeline-auth:qa-$auth_tag 
                        docker tag  devopseasylearning/s4-pipeline-db:$db_tag     devopseasylearning/s4-pipeline-db:qa-$db_tag 
                        docker tag  devopseasylearning/s4-pipeline-ui:$ui_tag     devopseasylearning/s4-pipeline-ui:qa-$ui_tag 
                        docker tag  devopseasylearning/s4-pipeline-weather:$weather_tag devopseasylearning/s4-pipeline-weather:qa-$weather_tag 
                    '''
                }
            }
        }



   stage('Update DEV  charts') {
      when{  
          expression {
            env.ENVIRONMENT == 'DEV' }
          
            }
      
            steps {
                script {

                    sh '''
rm -rf S4-projects-charts || true
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





   stage('Update QA  charts') {
      when{  
          expression {
            env.ENVIRONMENT == 'QA' }
          
            }
      
            steps {
                script {

                    sh '''
rm -rf S4-projects-charts || true
git clone git@github.com:devopseasylearning/S4-projects-charts.git
cd S4-projects-charts

cat << EOF > charts/weatherapp-auth/qa-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-auth
  tag: qa-$auth_tag
EOF


cat << EOF > charts/weatherapp-mysql/qa-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-db
  tag: qa-$db_tag
EOF

cat << EOF > charts/weatherapp-ui/qa-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-ui
  tag: qa-$ui_tag
EOF

cat << EOF > charts/weatherapp-weather/qa-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-weather
  tag: qa-$weather_tag
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




   stage('Update Preprod  charts') {
      when{  
          expression {
            env.ENVIRONMENT == 'PREPROD' }
          
            }
      
            steps {
                script {

                    sh '''
rm -rf S4-projects-charts || true
git clone git@github.com:devopseasylearning/S4-projects-charts.git
cd S4-projects-charts

cat << EOF > charts/weatherapp-auth/preprod-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-auth
  tag: ${BUILD_NUMBER}
EOF


cat << EOF > charts/weatherapp-mysql/preprod-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-db
  tag: ${BUILD_NUMBER}
EOF

cat << EOF > charts/weatherapp-ui/preprod-values.yaml
image:
  repository: devopseasylearning/s4-pipeline-ui
  tag: ${BUILD_NUMBER}
EOF

cat << EOF > charts/weatherapp-weather/preprod-values.yaml
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

        stage('wait for argocd') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh '''
                     sleep 300
                    '''
                }
            }
        }


}

post {
    always {
      script {
        notifyUpgrade(currentBuild.currentResult, "POST")
      }
    }
    
  }



}






def notifyUpgrade(String buildResult, String whereAt) {
  if (Please_leave_this_section_as_it_is == 'origin/develop') {
    channel = 'development-alerts'
  } else {
    channel = 'development-alerts'
  }
  if (buildResult == "SUCCESS") {
    switch(whereAt) {
      case 'WARNING':
        slackSend(channel: channel,
                color: "#439FE0",
                message: "s4-weather-app: Upgrade starting in ${env.WARNTIME} minutes @ ${env.BUILD_URL}  Application s4-weather-app")
        break
    case 'STARTING':
      slackSend(channel: channel,
                color: "good",
                message: "s4-weather-app: Starting upgrade @ ${env.BUILD_URL} Application s4-weather-app")
      break
    default:
        slackSend(channel: channel,
                color: "good",
                message: "s4-weather-app: Upgrade completed successfully @ ${env.BUILD_URL}  Application s4-weather-app")
        break
    }
  } else {
    slackSend(channel: channel,
              color: "danger",
              message: "s4-weather-app: Upgrade was not successful. Please investigate it immediately.  @ ${env.BUILD_URL}  Application s4-weather-app")
  }
}