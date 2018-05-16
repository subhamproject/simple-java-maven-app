#!groovy

pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
  }
  agent any
  stages {
    stage('Build') {
      steps {
        script {
          sh '''
          chmod a+x build.sh
          ./build.sh
          '''
        }
      }
    }
  }
}
