# Zammad Helm Chart

A [Helm](https://helm.sh) chart to install [Seafile](https://seafile.com) on [Kubernetes](https://kubernetes.io)

[Seafile](https://seafile.com/) is an open source file sync and share platform,
focusing on reliability and performance.

## Introduction

This chart will do the following:

- Install `Deployment`s for Seafile. Mainly one Seafile-Backend-Server and multiple Seafile-Frontend-Server
- Install Elasticsearch, Memcached, MariaDB & Minio (optional) as requirements

Be aware that the Zammad Helm chart version is different from the actual Zammad version.

> [!IMPORTANT]  
> Be aware that the Seafile Helm chart is provided by [datamate](https://datamate.org), the primary support and sales partner in Europe.
> Currently this Helm Chart is still a Beta version. Only use this if you are familiar with Kubernetes and Helm

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Cluster with at least 4GB of free RAM

## Installing the Chart

To install the chart use the following:

```console
helm repo add datamate https://datamate-rethink-it.github.io/seafile-helm
helm upgrade --install seafile datamate/seafile
```

Once the Seafile pod (like `pod/seafile-5c4ff86d85-vrlr6`) is ready, it can be accessed using the ingress or port forwarding.
To use port forwarding:

```console
kubectl port-forward service/seafile 8787
```

Now you can open <http://localhost:8787> in your browser.

## Uninstalling the Chart

To remove the chart again use the following:

```console
helm delete seafile
```

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run this configuration command:

```console
helm show values datamate/seafile
```
