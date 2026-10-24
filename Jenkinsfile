pipeline {
    agent any

    environment {
        EC2_HOST = '13.53.175.232'
        EC2_USER = 'ubuntu'
        APP_NAME = 'mi-deploy-nginx'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Neifer05/deploy-nginx.git'
            }
        }

        stage('Build & Deploy to AWS EC2') {
            steps {
                sshagent(['aws-ec2-key']) {
                    // Usamos -T para evitar que la terminal interactiva de SSH bloquee el flujo de datos de Docker
                    sh '''
                        ssh -T -o StrictHostKeyChecking=no ubuntu@$EC2_HOST "
                            if [ -d 'mi-proyecto' ]; then
                                cd mi-proyecto && git pull origin main
                            else
                                git clone https://github.com/Neifer05/deploy-nginx.git mi-proyecto
                            fi
                        "
                        
                        ssh -T -o StrictHostKeyChecking=no ubuntu@$EC2_HOST "
                            cd mi-proyecto && docker build --no-cache -t $APP_NAME .
                        "
                        
                        ssh -T -o StrictHostKeyChecking=no ubuntu@$EC2_HOST "
                            docker stop $APP_NAME || true
                            docker rm $APP_NAME || true
                            docker run -d --name $APP_NAME -p 80:80 $APP_NAME
                        "
                    '''
                }
            }
        }
    }
}
