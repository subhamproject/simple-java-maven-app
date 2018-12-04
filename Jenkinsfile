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
     // [expressionType: 'JSONPath', key: 'ref', value: '$.ref'],
      [expressionType: 'JSONPath', key: 'changed_files', regexpFilterExpression: "$.commits[*].['modified','added','removed'][*]", value: '$.changed_files']
     ],
     causeString: 'Generic webhook trigger',
     regexpFilterExpression: 'src/main/java/com/[^"]+?' + BRANCH_NAME,
     regexpFilterText: '$changed_files',
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
