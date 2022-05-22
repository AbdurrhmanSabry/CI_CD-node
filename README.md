# CI/CD Pipeline 


## Description
Using Jenkins pipeline to build a docker image of a node.js app and deploy it on a Jenkins slave (aws EC2 instance). Tha app also connect to a Elasticache Redis and RDS mysql
## Tools
<p align="center">
<img src="https://www.vectorlogo.zone/logos/docker/docker-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/jenkins/jenkins-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/amazon_aws/amazon_aws-icon.svg"/>
<img src="https://www.vectorlogo.zone/logos/nodejs/nodejs-ar21.svg"/>
<img src="https://www.vectorlogo.zone/logos/slack/slack-ar21.svg"/>
</p>

## Infrastructure:

Follow the infrastructure pipeline steps before running  this pipeline, You can go to the repo of the infrastructure repo by clicking the following icon: 

<p align="center">
<a href="https://github.com/AbdurrhmanSabry/aws-architecture.git"><img src="https://www.vectorlogo.zone/logos/github/github-tile.svg" width="50" height="50"/></a>
</p>

## Getting Started

### 1- Prequisites:
- Make sure you have a Jenkins Slave EC2 instance online and running successfully
- Add the credentials of  your dockerhub account and RDS instance of type (username and password)
- Add to the Jenkinsfile the endpoints of both the RDS and ElastiCache
- Add a channel for slack in the Jenkinsfile
To cojfigure slack in Jenkins follow the steps described in the Infrastructure repo: https://github.com/AbdurrhmanSabry/aws-architecture.git
```bash
environment {
        rds_hostname = 'RSD_Endpoint'
        redis_hostname    = 'REDIS_Endpoint'
        }
```

### 2- Building  Pipeline
- Save and Build the pipeline

- To check the result, hit one the following endpoint of the ALB we created using terraform 
    ```
    http://ALB_ENDPOINT/
    ```
    ```
    http://ALB_ENDPOINT/db
    ```
    ```
    http://ALB_ENDPOINT/redis
    ```

