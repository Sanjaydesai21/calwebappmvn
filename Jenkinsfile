pipeline {
    agent any

    tools {
        maven 'maven1'
    }

    environment{
        my_aws_credentials = credentials('aws-access')
    }

    stages {
        stage('checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-pat', url: 'https://github.com/Sanjaydesai21/calwebappmvn.git'
                echo 'cloning successful'
            }
        }

        stage('build') {
            steps {
                sh '''
                mvn clean package
                ls -al
                '''
            }

            post {
                success {
                    archiveArtifacts 'target/*.war'
                    sh 'ls -la'
                }
            }
        }
        
        stage('testing') {
            steps{
                withSonarQubeEnv('sonar-env') {
                    sh 'mvn sonar:sonar'
                }
            }
        }

        stage("Quality Gates"){
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

        stage("Sonar Report") {
            steps {
                echo "SonarQube report generated successfully. Please check the SonarQube dashboard for details."
            }
        }

        stage("docker build & push"){
            steps {
                sh '''
                    aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 194226864100.dkr.ecr.ap-south-1.amazonaws.com
                    docker build -t calcwebappmvn:v1 .
                    docker tag calcwebappmvn:v1 194226864100.dkr.ecr.ap-south-1.amazonaws.com/calcwebappmvn:v2
                    docker push 194226864100.dkr.ecr.ap-south-1.amazonaws.com/calcwebappmvn:v2
                '''
            }
        }
        stage('Eks deploy') {
            steps {
                sh '''
                    aws eks update-kubeconfig --region ap-south-1 --name my-cluster-sanjay
                    kubectl apply -f calc-deployment-svc.yaml
                    kubectl get pods
                    sleep 30
                    echo "Waiting for LoadBalancer DNS..."
                    while [ -z "$(kubectl get svc calc-loadbalancer -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')" ]; do
                        echo "Waiting..."
                        sleep 10
                    done
                    echo "LoadBalancer DNS:"
                    kubectl get svc calc-loadbalancer -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
                '''
            }

            post {
                success {
                    echo 'EKS deployment completed successfully.'
                }
                failure {
                    echo 'EKS deployment failed. Please check the logs for details.'
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline completed successfully.'

            emailext(
                subject: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                mimeType: 'text/html',
                body: """
                <h2>Jenkins Pipeline Successful</h2>

                <b>Job Name:</b> ${env.JOB_NAME}<br>
                <b>Build Number:</b> ${env.BUILD_NUMBER}<br>
                <b>Status:</b> SUCCESS<br>
                <b>Build URL:</b>
                <a href="${env.BUILD_URL}">${env.BUILD_URL}</a><br><br>

                <b>Project:</b> Calculator Web App<br>
                <b>Deployment:</b> AWS EKS<br>
                <b>Docker Image:</b> calcwebappmvn:v2
                """,
                attachLog: true,
                to: "sanjydesai2101@gmail.com"
            )
        }

        failure {
            echo 'Pipeline failed. Please check the logs for details.'

            emailext(
                subject: "❌ FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                mimeType: 'text/html',
                body: """
                <h2>Jenkins Pipeline Failed</h2>

                <b>Job Name:</b> ${env.JOB_NAME}<br>
                <b>Build Number:</b> ${env.BUILD_NUMBER}<br>
                <b>Status:</b> FAILED<br>
                <b>Build URL:</b>
                <a href="${env.BUILD_URL}">${env.BUILD_URL}</a><br>

                Please check the console logs for more details.
                """,
                attachLog: true,
                to: "sanjydesai2101@gmail.com"
            )
        }
    }
}
