pipeline {
    agent {label 'ec2_private_slave'}
    environment {
        rds_hostname = 'terraform-20220516200042997200000002.c1vpvridguyo.us-east-1.rds.amazonaws.com'
        redis_hostname    = 'redis-cluster.nvp9dd.0001.use1.cache.amazonaws.com'
        }
    stages {
        stage('CI') {
            steps {
                // Build the Dockerfile
                sh "docker build . -t abdurrhmansm/node_app_rds:latest"
                // Push the image to our account

                //first login to docker
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){

                    sh "docker login -u ${USERNAME} -p ${PASSWORD}"

                }

                //now, push the image
                sh "docker push abdurrhmansm/node_app_rds:latest"
                
            }
        }
        stage('CD') {
            steps {
            withCredentials([usernamePassword(credentialsId: 'RDS_CRED', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                //Run the docker image with 
                sh "docker run -d -it -p 3000:3000 --env RDS_HOSTNAME=${rds_hostname} --env RDS_USERNAME=${USERNAME} --env RDS_PASSWORD=${PASSWORD} --env REDIS_HOSTNAME=${redis_hostname}  abdurrhmansm/node_app_rds:latest"
            }
                
            }
        }
    }
}
