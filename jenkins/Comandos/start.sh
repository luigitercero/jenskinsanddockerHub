#!/bin/bash
docker run --name jenkins-docker -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock jenkins-tarea