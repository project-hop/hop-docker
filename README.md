
# project-hop-in-the-cloud

A **Hop Docker image** supporting both **short-lived** and **long-lived** setups.

## Hop Config

Set HOP_HOME to the `project-a` directory (absolute path) when using Hop locally (on your laptop).

Example:

```
export HOP_HOME=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
export HOP_METADATA_FOLDER=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a
```

# Running the Container

The container image is available on [Docker Hub](https://hub.docker.com/repository/docker/projecthop/hop).

## Container Folder Structure


Directory	| Description
---	|---
`/opt/project-hop`	| location of the hop package
`/files`	| here you should mount a directory that contains the **hop and project config** as well as the **workflows and pipelines**.

## Environment Variables

You can provide values for the following environment variables:


Environment Variable	| Required	| Description
---	|----	|---
`HOP_LOG_LEVEL`	| No	| Specify the log level. Default: `Basic`. Optional.
`HOP_FILE_PATH`	| Yes	| Path to hop workflow or pipeline
`HOP_LOG_PATH`	| No	| File path to hop log file
`HOP_CONFIG_DIRECTORY`	| Yes	| Path to the Hop config folder
`HOP_RUN_ENVIRONMENT`	| Yes	| Name of the Hop run environment to use
`HOP_RUN_CONFIG`	| Yes	| Name of the Hop run configuration to use
`HOP_RUN_PARAMETERS`	| No	| Parameters that should be passed on to the hop-run command. Specify as comma separated list, e.g. `PARAM_1=aaa,PARAM_2=bbb`. Optional.
`HOP_OPTIONS`	| No	| Any JRE options you want to set
`HOP_SHARED_JDBC_DIRECTORY`	| No	| Path to the directory where the JDCB drivers are located
`HOP_SERVER_USER`	| No	| Username for hop-server, only valid in long-lived containers. Default `cluster`
`HOP_SERVER_PASS`	| No	| Password for hop-server user, only valid in long-lived containers. Default `cluster`

The `Required` column relates to running a short-lived container.

## How to run the Container

The most common use case will be that you run a **short-lived container** to just complete one Hop workflow or pipeline.

Example for running a **workflow**:

```bash
WORKING_DIR="$( cd "$( /usr/bin/dirname "$0" )" && pwd )"
VOLUME_DIR=${WORKING_DIR}/../tests/project-a

docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_FILE_PATH=/files/pipelines-and-workflows/main.hwf \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop \
  --env HOP_RUN_ENVIRONMENT=project-a-dev \
  --env HOP_RUN_CONFIG=classic \
  --env HOP_RUN_PARAMETERS=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1 \
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:0.20-20200505.141953-75
```

If you need a **long-lived container**, this option is also available. Run this command e.g.:

```bash
docker run -it --rm \
  --env HOP_LOG_LEVEL=Basic \
  --env HOP_CONFIG_DIRECTORY=/files/config/hop \
  --env HOP_SERVER_USER=admin \
  --env HOP_SERVER_PASS=admin \
  -p 8080:8080
  -v ${VOLUME_DIR}:/files \
  --name my-simple-hop-container \
  diethardsteiner/project-hop:0.20-20200505.141953-75
```

You can then access the hop-server UI from your dockerhost at `http://localhost:8080`

# Local Development

## How to run the workflow locally

To just test the workflow locally without Docker:

```
export HOP_CONFIG_DIRECTORY=/Users/diethardsteiner/git/hop-docker/tests/project-a/config/hop
~/apps/hop/hop-run.sh \
  --file=/Users/diethardsteiner/git/project-hop-in-the-cloud/project-a/pipelines-and-workflows/main.hwf \
  --environment=project-a-local \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```

To test the workflow within the **Docker container**:  

```
./hop-run.sh \
  --file=/files/pipelines-and-workflows/main.hwf \
  --environment=project-a-dev \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```


## How to run the workflow within the Docker container

If you spin up a docker container with the hop server running:

```
./hop-run.sh --file=/home/hop/project-hop-in-the-cloud/project-a/pipelines-and-workflows/main.hwf --runconfig=classic --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```

## Tests

### JDBC Drivers

There is currently one test for loading external JDBC drivers. The test example relies on a **PostgreSQL** database being available. Place the drivers in `hop-docker/tests/project-a/jdbc-drivers`.

# Shortcomings

Currently the `hop-server` support is minimal.

