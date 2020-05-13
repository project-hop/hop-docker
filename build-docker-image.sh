#!/bin/bash

# SET ENV VARS
DOCKER_HOP_TAG=0.20-20200505.141953-75
WORKING_DIR=${0:a:h} 
# working directory should be /Users/diethardsteiner/git/project-hop-in-the-cloud

# download hop
wget -O ./resources/hop.zip https://artifactory.project-hop.org/artifactory/hop-snapshots-local/org/hop/hop-assemblies-client/0.20-SNAPSHOT/hop-assemblies-client-${DOCKER_HOP_TAG}.zip
unzip ./resources/hop.zip

# build docker image
docker build -t diethardsteiner/project-hop:${DOCKER_HOP_TAG} .

# start tests ...


export HOP_CONFIG_DIRECTORY=${WORKING_DIR}/project-a/config/hop

# start container - pipeline example
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/simple.hpl \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
  --env HOP_RUN_ENVIRONMENT=project-a-dev \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS= \
  -v ${WORKING_DIR}/project-a:/files \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}
  
# start container - workflow example
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/main.hwf \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
  --env HOP_RUN_ENVIRONMENT=project-a-dev \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1 \
  -v ${WORKING_DIR}/project-a:/files \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}
  
# For this to work .hop has to reside in $HOME
# $HOP_HOME is support correctly, however, not $HOP_METASTORE_FOLDER
# hop still expects the metastore to reside in $HOME/.hop/metastore

# start container - long-lived process example
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
  -v ${WORKING_DIR}/project-a:/home/hop \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:${DOCKER_HOP_TAG}

# testing finished ...
  
  
# publish
docker login --username=diethardsteiner
docker push diethardsteiner/project-hop:${DOCKER_HOP_TAG}