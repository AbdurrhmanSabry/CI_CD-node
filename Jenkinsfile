pipeline {
    agent {label 'ec2-slave'}
    environment {
        rds_hostname = 'terraform-20220520193416936700000002.crw6baw4vjmp.us-east-1.rds.amazonaws.com'
        redis_hostname    = 'redis-cluster.s0tb98.0001.use1.cache.amazonaws.com'
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
            steps {
            withAWS(credentials:'AWS_KEYS', region: 'us-east-1'){
                sh 'export rds_address=$(aws ssm get-parameter --name "rds_endpoint" --query "Parameter.Value")'
                sh 'export redis_address=$(aws ssm get-parameter --name "elasticahe-address" --query "Parameter.Value")'
                sh 'echo $rds_address'
                sh 'echo $redis_address'
            }
            withAWS(credentials: 'AWS_KEYS', region: 'us-east-1') {
                sh 'terraform -chdir=./terraform fmt'
                }
            withCredentials([usernamePassword(credentialsId: 'RDS_CRED', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                //Run the docker image with 
                sh "docker run -d -it -p 3000:3000 --env RDS_HOSTNAME=$rds_address --env RDS_USERNAME=${USERNAME} --env RDS_PASSWORD=${PASSWORD} --env REDIS_HOSTNAME=$redis_address --env RDS_PORT=3306 abdurrhmansm/node_app_rds:latest"
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
        }
    }
}
