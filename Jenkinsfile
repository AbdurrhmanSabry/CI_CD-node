pipeline {
    agent {label 'ec2-slave'}
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
            post {
                success {
                   slackSend(channel: 'dev-ops', color: 'good', message: "CI success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
               }
               failure {
                   slackSend(channel: 'dev-ops', color: 'danger', message: "CI failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
               }
            }
        }
        stage('CD') {
            environment {
                rds_hostname = '$(aws ssm get-parameter --name /dev/rdsdatabase/address --with-decryption --output text --query "Parameter.Value")'
                redis_hostname    = '$(aws ssm get-parameter --name /dev/elasticaheredis/address --output text --with-decryption --query "Parameter.Value" )'
                rds_username = '$(aws ssm get-parameter  --name username_rds  --output text  --query "Parameter.Value")'
                rds_password = '$(aws ssm get-parameter --name password_rds --with-decryption --output text --query "Parameter.Value")'
            }
            steps {
            withAWS(credentials:'AWS_KEYS', region: 'us-east-1'){
                //Run the docker image with 
             sh "docker run -d -it -p 3000:3000 --env RDS_HOSTNAME=${rds_hostname} --env RDS_USERNAME=${rds_username} --env RDS_PASSWORD=${rds_password} --env REDIS_HOSTNAME=${redis_hostname}  --env RDS_PORT=3306 abdurrhmansm/node_app_rds:latest"
            }
            
            }
            post {
                success {
                   slackSend(channel: 'dev-ops', color: 'good', message: "CD success - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
               }
               failure {
                   slackSend(channel: 'dev-ops', color: 'danger', message: "CD failure - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
               }
            }
        }
        stage('clean workspace') {
             steps {
                cleanWs()
         }   
    }
    }
}
