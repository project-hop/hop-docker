#!/bin/bash

source get-latest-hop-package.sh
echo "=== build script ==="
echo "latest version: ${HOP_LATEST_VERSION}"
# build docker image
docker build -t projecthop/hop:${HOP_LATEST_VERSION} ..

# start tests ...

echo "==== STARTING TESTS ===="

WORKING_DIR="$( cd "$( /usr/bin/dirname "$0" )" && pwd )"
VOLUME_DIR=${WORKING_DIR}/../tests/project-a

# start container - pipeline example
echo "- Testing short-lived container: hop pipeline example"
# docker run -it --rm \
docker run --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/simple.hpl \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
  --env HOP_RUN_ENVIRONMENT=project-a-dev \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS= \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  projecthop/hop:${HOP_LATEST_VERSION}
  
# start container - workflow example
echo "- Testing short-lived container: hop workflow example"
# docker run -it --rm \
docker run --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/main.hwf \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
  --env HOP_RUN_ENVIRONMENT=project-a-dev \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1 \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  projecthop/hop:${HOP_LATEST_VERSION}
  

# start container - long-lived process example
# docker run --rm \
#   --env HOP_LOG_LEVEL=Basic \
#   --env HOP_CONFIG_DIRECTORY=/files/config/hop/config \
#   -v ${VOLUME_DIR}:/files \
#   --name my-simple-hop-container \
#   projecthop/hop:${HOP_LATEST_VERSION}

# testing finished ...
  
  
# publish
# docker login --username=# diethardsteiner
# docker push projecthop/hop:${HOP_LATEST_VERSION}