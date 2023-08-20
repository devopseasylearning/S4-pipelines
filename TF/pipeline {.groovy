pipeline {
    agent any

    stages {
        stage('Use Secret') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'YOUR_CREDENTIAL_ID', variable: 'SECRET_VAR'),
                        ]) {
                        // Use the SECRET_VAR in this block
                        echo "My secret is ${SECRET_VAR}"  // Just an example, don't actually print secrets!
                    }
                }
            }
        }
    }
}


stage('backup') {

	      steps {
	        script {
	          withCredentials([
	            string(credentialsId: 'hostname', variable: 'HOSTNAME'),
	            string(credentialsId: 'username', variable: 'USERNAME'),
	            string(credentialsId: 'passwd', variable: 'PASSWORD')
	          ]) {

	            sh '''
                echo $HOSTNAME
                echo $USERNAME
                echo $PASSWORD
	            '''
	          }

	        }

	      }