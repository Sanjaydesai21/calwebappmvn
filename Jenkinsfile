pipeline {
    agent any

    tools {
        maven 'maven1'
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
    }
}
