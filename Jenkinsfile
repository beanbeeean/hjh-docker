pipeline { 
    environment { 
        repository = "beanbeeean/hjh-docker"  
        DOCKERHUB_CREDENTIALS = credentials('hjh') 
        dockerImage = '' 
  }
  agent any 
  stages { 
      stage('Building our image') { 
          steps { 
              script { 
                  sh "docker build -t $repository:$BUILD_NUMBER ." 
              }
          } 
      }
      stage('Login'){
          steps {
  	      withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')])
             {      
              sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD' 
             }
      }
      stage('Deploy our image') { 
          steps { 
              script {
                sh 'docker push $repository:$BUILD_NUMBER' 
              } 
          }
      } 
      stage('Cleaning up') { 
		  steps { 
              sh "docker rmi $repository:$BUILD_NUMBER" 
          }
      } 
  }
    }
