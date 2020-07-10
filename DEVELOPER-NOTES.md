# Local Development

## Environments


Environment	| Purpose
---	|----
`project-a-dev`	| Run processes locally without the Docker container. Requires Hop to be installed locally.
`project-a-test`	| Run processes within the Docker container


## How to run the workflow locally

To just test the workflow locally without Docker follow the steps outlined below. **Amend paths** to your local setup.


Define where you'd like to store the **Hop config**:

```
# Define location of the global Hop config
# workaround due to bug, see https://project-hop.atlassian.net/browse/HOP-463

export HOP_CONFIG_DIRECTORY=~/config/hop
echo "{}" | ${HOP_CONFIG_DIRECTORY}/hop-config.json
```

Register the `project-a-dev` with your **Hop config**:

> **Note**: This should point to the `tests/project-a` folder within the `hop-docker` repo.


```
# Create Hop project
./hop-conf.sh \
--project=project-a \
--project-create \
--project-home="/Users/diethardsteiner/git/hop-docker/tests/project-a" \
--project-config-file=project-config.json \
--project-metadata-base='${PROJECT_HOME}/metadata' \
--project-datasets-base='${PROJECT_HOME}/datasets' \
--project-unit-tests-base='${PROJECT_HOME}' \
--project-variables=VAR_PROJECT_TEST1=a,VAR_PROJECT_TEST2=b \
--project-enforce-execution=true


# Create Hop environment

## -- OPEN -- USE git repo config file instead --- ##

./hop-conf.sh \
--environment=project-a-dev \
--environment-create \
--environment-project=project-a \
--environment-purpose=development \
--environment-config-files="/Users/diethardsteiner/config/project-a/project-a-dev.json"

# Set variables for the env config
./hop-conf.sh \
--config-file="/Users/diethardsteiner/config/project-a/project-a-dev.json" \
--config-file-set-variables=VAR_ENV_TEST1=c,VAR_ENV_TEST2=d
````

Now you are ready to run the test processes:

```
./hop-run.sh \
  --file='${PROJECT_HOME}/pipelines-and-workflows/simple.hpl' \
  --project=project-a \
  --environment=project-a-dev \
  --runconfig=classic

./hop-run.sh \
  --file='${PROJECT_HOME}/pipelines-and-workflows/main.hwf' \
  --project=project-a \
  --environment=project-a-dev \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```


## How to run the workflow within the Docker container

If you spin up a docker container with the hop server running:

```
./hop-run.sh --file=/home/hop/hop-docker/project-a/pipelines-and-workflows/main.hwf \
  --project=project-a \
  --environment=project-a-test \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```

## Tests

### JDBC Drivers

There is currently one test for loading external JDBC drivers. The test example relies on a **PostgreSQL** database being available. Place the drivers in `hop-docker/tests/project-a/jdbc-drivers`.