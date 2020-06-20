# Local Development

## Environments


Environment	| Purpose
---	|----
`project-a-dev-env`	| Run processes locally without the Docker container. Requires Hop to be installed locally.
`project-a-test-env`	| Run processes within the Docker container


## How to run the workflow locally

To just test the workflow locally without Docker follow the steps outlined below. **Amend paths** to your local setup.


Define where you'd like to store the **Hop config**:

```
# Define location of the global Hop config
# workaround due to bug, see https://project-hop.atlassian.net/browse/HOP-463

export HOP_CONFIG_DIRECTORY=~/config/hop
echo "{}" | ${HOP_CONFIG_DIRECTORY}/config.json
```

Register the `project-a-dev-env` with your **Hop config**:

> **Note**: This should point to the `tests/project-a` folder within the `hop-docker` repo.


```
# Create Hop environment
./hop-conf.sh \
-environment=project-a-dev-env \
-environment-create \
--environments-home="/Users/diethardsteiner/git/hop-docker/tests/project-a"
````

Now you are ready to run the test processes:

```
~/apps/hop/hop-run.sh \
  --file=/Users/diethardsteiner/git/hop-docker/tests/project-a/pipelines-and-workflows/simple.hpl \
  --environment=project-a-dev-env \
  --runconfig=classic

~/apps/hop/hop-run.sh \
  --file=/Users/diethardsteiner/git/hop-docker/tests/project-a/pipelines-and-workflows/main.hwf \
  --environment=project-a-dev-env \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```

To test the workflow within the **Docker container**:  

```
./hop-run.sh \
  --file=/files/pipelines-and-workflows/main.hwf \
  --environment=project-a-dev-env \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```


## How to run the workflow within the Docker container

If you spin up a docker container with the hop server running:

```
./hop-run.sh --file=/home/hop/hop-docker/project-a/pipelines-and-workflows/main.hwf \
  --environment=project-a-test-env \
  --runconfig=classic \
  --parameters=PARAM_LOG_MESSAGE=Hello,PARAM_WAIT_FOR_X_MINUTES=1
```

## Tests

### JDBC Drivers

There is currently one test for loading external JDBC drivers. The test example relies on a **PostgreSQL** database being available. Place the drivers in `hop-docker/tests/project-a/jdbc-drivers`.