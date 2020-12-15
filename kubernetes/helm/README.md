# Hop

The [Hop](https://hop.apache.org/) Orchestration Platform, or Apache Hop (Incubating), aims to facilitate all aspects of data and metadata orchestration.

## Introduction

This chart deploys Hop on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

## Installing the chart

**Currently this chart is not deployed to an official repository yet. See the HELM-NOTES file on how to deploy and install it.**

```console
$ helm install stable/hop
```

To install the chart with the release name my-release:

```console
$ helm install --name my-release stable/hop
```

## Uninstalling the chart

To uninstall/delete the my-release deployment:

```console
$ helm delete --purge my-release
```

The command removes nearly all the Kubernetes components associated with the chart and deletes the release.

## Configuration