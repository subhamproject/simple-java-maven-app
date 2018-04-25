pipeline
{
    options
    {
        buildDiscarder(logRotator(numToKeepStr: '3'))
    }
    agent any
	 tools { 
        maven 'Maven 3.5.3' 
        jdk 'JDK 8' 
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
	  
	//stage ('Initialize Mvn PATH') {
          //  steps {
            //    sh '''
            //        echo "PATH = ${PATH}"
             //       echo "M2_HOME = ${M2_HOME}"
            //    ''' 
          //  }
       // }
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
