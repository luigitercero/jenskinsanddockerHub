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

# Problem:

You are trying to run a docker container or do the docker tutorial, but you only get an error message like this:
```
    docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.26/containers/create: dial unix /var/run/docker.sock: connect: permission denied.
    See 'docker run --help'.
````
# solution

Solving Docker permission denied while trying to connect to the Docker daemon socket
Problem:

You are trying to run a docker container or do the docker tutorial, but you only get an error message like this:

    docker: Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post http://%2Fvar%2Frun%2Fdocker.sock/v1.26/containers/create: dial unix /var/run/docker.sock: connect: permission denied.
    See 'docker run --help'.

Solution:

The error message tells you that your current user can’t access the docker engine, because you’re lacking permissions to access the unix socket to communicate with the engine.

As a temporary solution, you can use sudo to run the failed command as root (e.g. sudo docker ps).
However it is recommended to fix the issue by adding the current user to the docker group:

Run this command in your favourite shell and then completely log out of your account and log back in (or exit your SSH session and reconnect, if in doubt, reboot the computer you are trying to run docker on!):


```
    sudo usermod -a -G docker $USER
```
https://techoverflow.net/2017/03/01/solving-docker-permission-denied-while-trying-to-connect-to-the-docker-daemon-socket/
