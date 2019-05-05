# Desplegar una imagen Docker desde Jenkins

Debe crear una repositorio en docker hub



Debe instalar docker en la maquina host
dirigirse a la raiz del proyecto y construir la imagen
````
docker build -t [nombre] .
````
ejecutar jenkins desde docker con el nombre que se le asigno
con la carta
```docker run --name jenkins-docker -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock jenkins-tarea
```
configurarcion basica en jenkins
## agregar las credenciasles de docker hub

para esto nos dirigimos a 
* jenkins home -> click en "credenital", 
* luego se ve un cuadrito con una casita y unas llaves y a la par se ve u castillo(global), damos click a global,  y nos redirecciona a otra pagina 
* damos click en add Credentials

llenamos los campos
* **username**: usuario de docker hub
* **password**: password de docker hub
* **ID**: con esto se va a identificar todo el registro. el cual se va a utlizar para **registryCredential** y se coloco 'dockerhub'
 

## Ejecutar job en jenkins
crear un job pipeline y agregar lo necesario para poder  clonar el repositorios

```
pipeline {
  environment {
    registry = "luigitercero/docker-test"
    registryCredential = 'dockerhub'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'link del repositorio'
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
```
Explicacion de pipeline
son la variables de que utilizrara para crear el contenedor

````
environment {
    registry = "docker_hub_account/repository_name"
    registryCredential = 'dockerhub'
}
````

Es el paso donde construimos una imagen apartir de jenkins y el tag
```
stages {
  stage('Building image') {
    steps{
      script {
        docker.build registry + ":$BUILD_NUMBER"
      }
    }
  }
}
```


