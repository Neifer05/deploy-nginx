pipeline {
    agent any

    environment {
        // Tu IP pública de la EC2 que me pasaste antes
        EC2_HOST = '13.53.175.232'
        EC2_USER = 'ubuntu'
        APP_NAME = 'mi-deploy-nginx'
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clona tu repositorio (cambia la URL por la tuya de GitHub)
                git branch: 'main', url: 'https://github.com/Neifer05/deploy-nginx'
            }
        }

        stage('Build & Deploy to AWS EC2') {
            steps {
                // Aquí usas el ID de la credencial SSH que acabamos de configurar en Jenkins
                sshagent(['aws-ec2-key']) {
                    sh '''
                        # 1. Copiamos los archivos necesarios a la EC2 (o construimos directamente allí)
                        # Para simplificar, clonamos o enviamos los archivos. Una opción limpia es hacer git pull en la EC2 o pasar el Dockerfile.
                        
                        # Vamos a hacer un ssh rápido para actualizar el código y relanzar el contenedor
                        ssh -o StrictHostKeyChecking=no $EC2_USER@$EC2_HOST "
                            if [ -d 'mi-proyecto' ]; then
                                cd mi-proyecto && git pull origin main
                            else
                                git clone https://github.com/tu-usuario/tu-repo.git mi-proyecto && cd mi-proyecto
                            fi
                            
                            # Construir la imagen Docker dentro de la EC2
                            docker build -t $APP_NAME .
                            
                            # Parar el contenedor viejo si existe y arrancar el nuevo mapeando el puerto 80 al 80
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