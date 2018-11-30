#!groovy

pipeline {
  agent any
  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref']
     ],
     
     causeString: 'Triggered on $ref',
     
     token: 'abc123',
     
     printContributedVariables: true,
     printPostContent: true,
     
     silentResponse: false,
    
     regexpFilterText: '$ref',
     regexpFilterExpression: 'refs/heads/' + BRANCH_NAME
    )
  }
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
