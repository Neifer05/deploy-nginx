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
                        ssh -o StrictHostKeyChecking=no ubuntu@13.53.175.232 << 'EOF'
                            # 1. Clonar o actualizar el repositorio en la EC2
                            if [ -d 'mi-proyecto' ]; then
                                echo "Actualizando repositorio existente..."
                                cd mi-proyecto
                                git pull origin main
                            else
                                echo "Clonando repositorio por primera vez..."
                                git clone https://github.com/Neifer05/deploy-nginx.git mi-proyecto
                                cd mi-proyecto
                            fi
                            
                            # 2. Construir la imagen Docker (ya estamos dentro de 'mi-proyecto')
                            echo "Construyendo imagen Docker..."
                            docker build -t mi-deploy-nginx .
                            
                            # 3. Parar el contenedor viejo y arrancar el nuevo
                            echo "Desplegando contenedor..."
                            docker stop mi-deploy-nginx || true
                            docker rm mi-deploy-nginx || true
                            docker run -d --name mi-deploy-nginx -p 80:80 mi-deploy-nginx
                        EOF
                    '''
                }
            }
        }
    }
}
