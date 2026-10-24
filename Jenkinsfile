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
                    sh '''
                        # 1. Clonar o actualizar el repositorio real en la EC2
                        if [ -d 'mi-proyecto' ]; then
                            cd mi-proyecto && git pull origin main
                        else
                            git clone https://github.com/Neifer05/deploy-nginx.git mi-proyecto && cd mi-proyecto
                        fi
                        
                        # 2. Entrar a la carpeta del proyecto y construir la imagen Docker
                        cd mi-proyecto
                        docker build -t $APP_NAME .
                        
                        # 3. Parar el contenedor viejo si existe y arrancar el nuevo
                        docker stop $APP_NAME || true
                        docker rm $APP_NAME || true
                        docker run -d --name $APP_NAME -p 80:80 $APP_NAME
                    '''
                }
            }
        }
    }
}
