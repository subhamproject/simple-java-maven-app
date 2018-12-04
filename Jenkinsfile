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
      [key: 'ref', value: '$.ref'],
      [key: 'changed_files', regexpFilter: '$.commits[*].['modified','added','removed'][*]', value: '$.changed_files']
     ],
     causeString: 'Triggered on $ref',
     regexpFilterExpression: 'generic refs/heads/' + BRANCH_NAME,
     regexpFilterText: '$repository $ref',
     printContributedVariables: true,
     printPostContent: true
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
