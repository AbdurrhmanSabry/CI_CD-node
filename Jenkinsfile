pipeline {
    agent {label 'ec2-slave'}
    environment {
        rds_hostname = 'terraform-20220516183947561300000002.crw6baw4vjmp.us-east-1.rds.amazonaws.com'
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