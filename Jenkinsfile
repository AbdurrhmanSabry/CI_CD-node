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
                //Run the docker image with 
             sh 'docker run -d -it -p 3000:3000 --env RDS_HOSTNAME=$(aws ssm get-parameter --name "rds_endpoint" --with-decryption --output text --query "Parameter.Value") --env RDS_USERNAME="admin" --env RDS_PASSWORD="admin123456789" --env REDIS_HOSTNAME=$(aws ssm get-parameter --name "elasticahe-address" --output text --with-decryption --query "Parameter.Value") --env RDS_PORT=3306 abdurrhmansm/node_app_rds:latest'
            
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
    }
}
// pipeline {
//     agent {label 'ec2-slave'}
//     environment {
//         dockerhub=credentials('dockerhub')
//         rds_creds=credentials('RDS_CRED')
//         rds_endpoint= 'terraform-20220515144434445300000002.crw6baw4vjmp.us-east-1.rds.amazonaws.com'
//         redis_endpoint= 'redis-cluster.s0tb98.0001.use1.cache.amazonaws.com:6379'
//     }
//     stages {
//         stage('CI') {
//             steps {
//                 git branch: 'rds_redis',
//                 credentialsId: 'github',
//                 url: 'https://github.com/AbdurrhmanSabry/jenkins_nodejs_example.git'
//                 sh 'docker build -t  abdurrhmansm/node_app_redis_rds:latest .'
//                 sh 'docker login -u $dockerhub_USR -p $dockerhub_PSW'
//                 sh 'docker push abdurrhmansm/node_app_redis_rds:latest'
//             }
//         }
//         stage('CD'){
//             steps{
//                 sh 'docker run -p 3000:3000 --env RDS_HOSTNAME=${rds_endpoint} --env RDS_USERNAME=${rds_creds_USR} --env RDS_PASSWORD=${rds_creds_PSW} --env REDIS_HOSTNAME=${redis_endpoint} -it -d abdurrhmansm/node_app_redis_rds:latest'
//             }
//         }
//     }
// }