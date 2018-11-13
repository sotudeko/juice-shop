pipeline {
    // agent {
    //     docker {
    //         image 'node:6-alpine'
    //         args '-p 3000:3000'
    //     }
    // }
    agent any
    
    environment {
        CI = 'true' 
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Nexus IQ Scan') {
      		steps {
				script {
					// def policyEvaluation = nexusPolicyEvaluation failBuildOnNetworkError: false, iqApplication: 'juice-shop', iqStage: 'build', jobCredentialsId: 'nodeuser'
                    nexusPolicyEvaluation failBuildOnNetworkError: true, iqApplication: selectedApplication('juice-shop'), iqScanPatterns: [[scanPattern: '**/node_modules/*']], iqStage: 'build', jobCredentialsId: 'nodeuser'
                    // SCAN_URL = "${policyEvaluation.applicationCompositionReportUrl}"
                }
      		}
    	}
        stage('Scan result'){
            steps {
                // echo "scan url: ${SCAN_URL}"
                echo "user: ${USER}"
                echo "job name: ${JOB_NAME}"
                echo "build id: ${BUILD_ID}"
                echo "build url: ${BUILD_URL}"
                echo "build tag: ${BUILD_TAG}"
            }
        }
    }
}