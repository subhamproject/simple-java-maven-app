pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    agent any
	 tools { 
        maven 'Maven 3.5.3' 
        jdk 'jdk-1.8.0.161' 
    }
	// Define Environemnt Variable 
    environment 
    {
	VERSION = 'latest'
        PROJECT = 'rcx-test-vf'
        IMAGE = 'rcx-test-vf:latest'
        ECRURL = 'https://254847454774.dkr.ecr.ap-southeast-1.amazonaws.com/rcx-test-vf'
        CRED = 'ecr:ap-southeast-1:demo_aws_cred'
    }
    stages
    {
 // Clean workspace
	stage ('Clear workspace')
	{
	steps{
	deleteDir()
	}
	}
	
	// Clone git repository
	stage ('Clone repository') 
	{
	steps 
	{
	git poll: true,url: 'https://github.com/subhamproject/simple-java-maven-app.git'
	}
	}
	  
	stage ('Initialize Java PATH') {
           steps {
              sh export PATH="$PATH:/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-0.b14.36.amzn1.x86_64/jre/bin"
                   }
       }
	    stage('Mvn compile') {
      steps {
        sh 'mvn clean install'
      }
    }
	// Build Docker image
     stage('Build Docker Image')
        {
            steps
            {
                script
                {
                    // Build the docker image using a Dockerfile
			docker.build('${IMAGE}')
                }
            }
        }
		// Push Docker images to AWS ECR Or Docker HUB as applicable
        stage('Push Image to ECR')
        {
            steps
            {
                script
                {
                  docker.withRegistry(ECRURL,CRED)
                //  docker.withRegistry('https://920995523917.dkr.ecr.us-east-1.amazonaws.com', 'ecr:us-east-1:demo_aws_cred')
				  
                    {
			    docker.image(IMAGE).push()
                    }
                }
            }
        }
    }

    post
    {
        always
        {
            // make sure that the Docker image is removed
            sh "docker rmi ${IMAGE} | true"
        }
		success {
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Sucess: ${currentBuild.fullDisplayName}",
          body: "successfully build ${env.BUILD_URL}"
    }
	failure {
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
          body: "Something is wrong with ${env.BUILD_URL} Please Check the logs"
    }
	unstable {
      // notify users when the Pipeline fails
      mail to: 'smandal@rythmos.com',
          subject: "Unstable Pipeline: ${currentBuild.fullDisplayName}",
          body: "Build is not stable,Please check the logs ${env.BUILD_URL}"
    }
    }
}
