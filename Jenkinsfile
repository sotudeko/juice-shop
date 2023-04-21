pipeline {

  agent any
        
  environment {
    SBOM_FILE = "juice-shop-bom.xml"
  }

  stages {

    stage ('Clean') {
      steps {
        script {
          cleanWs deleteDirs: true, patterns: [[pattern: 'node_modules', type: 'INCLUDE'], [pattern: 'package-lock.json', type: 'INCLUDE']]
        }
      }
    }

    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }

    stage('Install CycloneDX') {
      steps {
          sh 'npm install --save-dev @cyclonedx/cyclonedx-npm'
      }
      post {
        success {
          sh "npx @cyclonedx/cyclonedx-npm --output-format XML --output-file ${SBOM_FILE}"
        }
      }
    }

    stage('Directory listing') {
      steps {
          sh 'ls -lrt'
      }
    }

    stage('Nexus IQ Scan (directory)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('juice-shop-ci-dir'), \
              iqScanPatterns: [[scanPattern: '**/*' ]],
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

     stage('Nexus IQ Scan (target)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('juice-shop-ci-target'), \
              iqScanPatterns: [[scanPattern: '**/package.json'], [scanPattern: '**/package-lock.lock']],
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

    stage('Nexus IQ Scan (SBOM)') {
      steps {
        script {
            nexusPolicyEvaluation \
              advancedProperties: '', \
              enableDebugLogging: false, \
              failBuildOnNetworkError: false, \
              iqApplication: selectedApplication('juice-shop-ci-sbom'), \
              iqScanPatterns: [[scanPattern: "${SBOM_FILE}"]], 
              iqInstanceId: 'nexusiq', \
              iqStage: 'build', \
              jobCredentialsId: 'Sonatype'
        }
      }
    }

    stage('Nexus IQ Scan (CLI)'){
      steps {
          sh "rm -v ${SBOM_FILE}"
      }
      post {
        success {
          sh 'java -jar /opt/nxiq/nexus-iq-cli -t build -s http://localhost:8070 -a admin:admin123 -i juice-shop-ci-cli .'
        }
      }
    }
  }
}   