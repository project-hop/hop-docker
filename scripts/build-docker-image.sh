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

# start container - pipeline example - simple
echo "- Testing short-lived container: hop pipeline example - simple"
docker run --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/simple.hpl \
  --env HOP_RUN_ENVIRONMENT=project-a-test-env \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS= \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  projecthop/hop:${HOP_LATEST_VERSION}


# start container - workflow example - db connection
# jdbc drivers have to be placed in hop-docker/tests/project-a/jdbc-drivers
echo "- Testing short-lived container: hop pipeline example - db connection"
docker run --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/check-db-connection.hwf \
  --env HOP_SHARED_JDBC_DIRECTORY=/files/jdbc \
  --env HOP_RUN_ENVIRONMENT=project-a-test-env \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_POSTGRESQL_DB_CONNECTION_HOST=localhost,PARAM_POSTGRESQL_DB_CONNECTION_PORT=5432,PARAM_POSTGRESQL_DB_CONNECTION_USERNAME=diethardsteiner,PARAM_POSTGRESQL_DB_CONNECTION_PASSWORD=,PARAM_POSTGRESQL_DB_CONNECTION_DATABASE=test \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  projecthop/hop:${HOP_LATEST_VERSION}
  
# start container - workflow example
echo "- Testing short-lived container: hop workflow example"
docker run --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/main.hwf \
  --env HOP_RUN_ENVIRONMENT=project-a-test-env \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1 \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  projecthop/hop:${HOP_LATEST_VERSION}
  

# start container - long-lived process example
# docker run --rm \
#   --env HOP_LOG_LEVEL=Basic \
#   --env HOP_CONFIG_DIRECTORY=/files/config/hop \
#   -v ${VOLUME_DIR}:/files \
#   --name my-simple-hop-container \
#   projecthop/hop:${HOP_LATEST_VERSION}

# testing finished ...
  
  
# publish
# docker login --username=# diethardsteiner
# docker push projecthop/hop:${HOP_LATEST_VERSION}