pipeline {
    agent any

    tools {
        maven 'maven1'
    }

    environment {
        my_aws_credential = credentials('aws-access')
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/mayurpandit25/calcwebappmvn.git'
                echo 'clonning is successful'
            }
        }

        stage('Build') {
            steps {
                sh '''
                ls -la
                mvn clean package
                ls -la
                '''
            }

            post {
                success {
                    archiveArtifacts 'target/*.war'
                    sh 'ls -la'
                }
            }
        }

        stage('Artifact to S3') {
            steps {
                sh 'aws s3 cp /var/lib/jenkins/workspace/application-pipeline/target/calcwebapp.war s3://mayur-s3-bucket-amazon-123456/'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        try {
                            def qg = waitForQualityGate()
                            echo "Quality Gate Status: ${qg.status}"
                            if (qg.status != 'OK') {
                                error "Quality Gate failed: ${qg.status}"
                            }
                        } catch (Exception e) {
                            echo "Quality Gate check failed: ${e.message}"
                            error "Quality Gate stage failed"
                        }
                    }
                }
            }
        }

        stage('SonarQube Report') {
            steps {
                script {
                    echo "SonarQube Report successfully generated"
                }
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                ls -la
                docker build -t calwebapp:v1 .
                ls -la
                docker images
                '''
            }
        }

        stage('Docker push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 506995420953.dkr.ecr.us-west-2.amazonaws.com
                docker tag calwebapp:v1 506995420953.dkr.ecr.us-west-2.amazonaws.com/app_cal:latest
                docker push 506995420953.dkr.ecr.us-west-2.amazonaws.com/app_cal:latest
                '''
            }
        }
    }
}



