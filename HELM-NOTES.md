# Deploying Apache Hop with Helm on Kubernetes

This document contains technical documentation on how to deploy Apache Hop using Helm on a Kubernetes cluster.

## What is Helm?

Kubernetes can become very complex to manage using standard configuration files (services, pods, volumes, different releases, ... ) which is solved by the use of Helm. Helm is a package manager which can package everything into a simple configurable application. Helm offers easy installing, updating and removal.

> Helm installs charts into Kubernetes, creating a new release for each installation. And to find new charts, you can search Helm chart repositories.

## Prerequisites

The following prerequisites are needed to get started with Apache Hop and Helm.

- A repository which contains a working Hop Docker image
- A kubernetes cluster (Amazon EKS, Google GKE, minikube, ... )
- Helm [installed and configured](https://helm.sh/docs/intro/install/)

## The Hop Helm Chart

The following files form the Hop Helm Chart.

```
hop/
  Chart.yaml    # A YAML file containing information about the Hop chart
  charts/       # A directory containing charts which the Hop chart depends on (a database, a queue, ... ).
  templates/    # A directory which contains the Hop chart definitions which 
                # generate Kubernetes manifest files based on values
  values.yaml   # The default Hop configuration values
```

### Chart.yaml

```
apiVersion: v2
name: hop
description: A Helm chart for Apache Hop
type: application

# This is the chart version. This version number should be incremented each time you make changes
# to the chart and its templates, including the app version.
# Versions are expected to follow Semantic Versioning (https://semver.org/)
version: 0.1.0

# This is the version number of the Apache Hop Docker image. This version number should be
# incremented each time you make changes to the application. Versions are not expected to
# follow Semantic Versioning. They should reflect the version the application is using.
# For simplicity this is set to latest but may be changed to reflect different Hop versions.
appVersion: latest
```

## Templates and values

The `deployment.yaml` and `_helpers.tpl` files are located in the `templates/` directory and are used with the `values.yaml` file to generate a valid Kubernetes manifest.

### deployment.yaml

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "hop.fullname" . }}
  labels:
    {{- include "hop.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "hop.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "hop.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image:  "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: hello-port
          containerPort: 8080
        volumeMounts:
        - name: vol
          mountPath: /files
          readOnly: false
        env:
          - name: HOP_LOG_LEVEL
            value: {{ .Values.hopLogLevel }}
          - name : HOP_PROJECT_DIRECTORY
            value: {{ .Values.hopProjectDirectory }}
          - name : HOP_PROJECT_NAME
            value: {{ .Values.hopProjectName }}
          - name : HOP_ENVIRONMENT_NAME
            value: {{ .Values.hopEnvironmentName }}
          - name : HOP_ENVIRONMENT_CONFIG_FILE_NAME_PATHS
            value: {{ .Values.hopEnvironmentConfigFileNamePaths }}
          - name : HOP_SERVER_USER
            value: {{ .Values.hopServerUser }}
          - name : HOP_SERVER_PASS
            value: {{ .Values.hopServerPass }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
      volumes:
        - name: vol
          hostPath:
            path: /files
            type: Directory
```

### values.yaml

```
# Default values for hop.
# This is a YAML-formatted file.

replicaCount: 1
hopLogLevel: "Basic"
hopProjectDirectory: "/files"
hopProjectName: "test"
hopEnvironmentName: "test-env"
hopEnvironmentConfigFileNamePaths: "/files/project-config.json"
hopServerUser: "admin"
hopServerPass: "admin"

image:
  repository: hop
  pullPolicy: Never
  # Overrides the image tag whose default is the chart appVersion.
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

service:
  type: NodePort
  port: 8080

# Hop resources
resources:
  requests:
    memory: "1Gi"
    cpu: "1"
```

## Sharing Hop project configuration, workflows and pipelines

A valid project configuration is needed to run Apache Hop which means the Hop pod needs access to these files somehow, following are two methods to accomplish this.

### Persistent Volume

The above chart is configured to have a persistent volume mounted to the `/files` directory. This volume has to be mounted on the Kubernetes cluster and can point to a storage location which contains configuration, workflows and pipelines.

### Pulling from Git

This chart can be changed to pull configuration from Git rather than read it from a pre-mounted volume. This is done by adding a Git container which servers the configuration as a mountable volume.

First add the container to initContainers (configure `deployment.yaml` and `values.yaml` accordingly).

```
  ...
  initContainers:
        - name: clone-git-repo
          image: alpine/git
          volumeMounts:
          - name: vol
            mountPath: /tmp/git-repo
            readOnly: false
          command: ['sh', '-c', 
            'cd /tmp/git-repo; git clone <your-git-project>; chmod -R 777 *; echo $(ls -la)']
  ...
```

Then change the hopEnvironmentConfigFileNamePaths in `values.yaml` to point to your project configuration.

## Saving the Apache Hop Chart package

To save the package to a repository first add a registry.

`helm repo add registry address:port`

Run helm package in the chart directory to create the package.

`helm package .`

Upload the package to the registry.

`curl --data-binary "@hop-0.1.0.tgz" address:port/api/charts`

Refresh the packages.

`helm repo update`

You should now be able to install Hop from the registry.

`helm install your-registry/hop --generate-name`