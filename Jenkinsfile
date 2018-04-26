pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    agent any
	 tools { 
        maven 'Maven 3.5.3' 
       // jdk 'jdk-1.8.0.161' 
    }
	// Define Environemnt Variable 
    environment 
    {
	VERSION = 'latest'
        PROJECT = 'rcx-test-vf'
        IMAGE = 'rcx-test-vf:latest'
        ECRURL = 'https://920995523917.dkr.ecr.us-east-1.amazonaws.com/rcx-test-vf'
        CRED = 'ecr:ap-southeast-1:demo_aws_cred'
    }
    stages
     {	  
	stage('Maven Build') {
      steps {
        sh 'mvn clean package'
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
	     //  Login to ECR before pushing image
	     
	stage('ECR login')
	     {
		steps
		    {
	sh '''  
	#!/bin/bash
	 export PATH="$PATH:/home/jenkins/.local/bin"
	 aws ecr get-login --no-include-email |bash
	   '''
			  
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
            // Delete old unused images to houskeep diskspace
            sh '''
	    docker rmi ${IMAGE} | true
	    docker rmi $(docker images -q -f dangling=true) >> /dev/null
	    sh /opt/jenkins/clear-ecr-image.sh "$PROJECT"  >> /dev/null
	    '''
        }
   	success {
	// clear work space
	deleteDir()
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
