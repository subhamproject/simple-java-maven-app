pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'ref', value: '$.ref']
      [key: 'changed_files', value: "$.commits[*].['modified','added','removed'][*]"]
     ],
     
     causeString: 'Triggered on $ref',
     
     token: 'env.JOB_NAME',
     
     printContributedVariables: true,
     printPostContent: true,
     
     silentResponse: false,
    
     regexpFilterText: '$ref $changed_files',
     //regexpFilterExpression: 'refs/heads/' + BRANCH_NAME
       regexpFilterExpression: 'jenkins_java/src/main/java/com/[^"]+?'
    )
  }
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                   // junit 'target/surefire-reports/*.xml'
                    step([$class: 'Publisher', reportFilenamePattern: '**/target/surefire-reports/testng-results.xml'])
                }
            }
        }
    }
}
