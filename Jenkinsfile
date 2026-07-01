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

    }
}
