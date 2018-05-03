pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '15'))
    }
	agent any
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
	 agent {
	 docker 
	 {
	 image '920995523917.dkr.ecr.us-east-1.amazonaws.com/container-image:maven'
         args '-v $HOME/.m2:/var/lib/jenkins/.m2 -e MAVEN_CONFIG=/var/lib/jenkins/.m2'
	 }
	 }
	 steps {
                sh 'mvn -Duser.home=/var/lib/jenkins clean package'
                dir("${env.WORKSPACE}/target") {
                    stash name: 'package', includes: '*.jar'
                }
            }
         }
	// Build Docker image
     stage('Build Docker Image')
        {
            steps
            {
                script
                {
	         dir("${env.WORKSPACE}/target") {
                        unstash 'package'
                    }
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
	 aws ecr get-login --no-include-email --region us-east-1 |bash
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
	    RUN=$(docker ps -aq) /dev/null
	    if [ -n "$RUN" ]
	    then
	    docker rm -f $RUN
	    fi
	    IMG=$(docker images -q -f dangling=true) >> /dev/null
	    if [ -n "$IMG" ]
	    then
	    docker rmi  $IMG >> /dev/null
	    fi
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
