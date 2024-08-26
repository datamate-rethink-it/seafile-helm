# Seafile Helm Chart

A [Helm](https://helm.sh) chart to install [Seafile](https://seafile.com) on [Kubernetes](https://kubernetes.io)

[Seafile](https://seafile.com/) is an open source file sync and share platform,
focusing on reliability and performance.

## Introduction

This chart will do the following:

- Install `Deployment`s for Seafile. Mainly one Seafile-Backend-Server and multiple Seafile-Frontend-Server
- Install Elasticsearch, Memcached, MariaDB & Minio (optional) as requirements

Be aware that the Seafile Helm chart version is different from the actual Seafile version.

> [!IMPORTANT]  
> Be aware that the Seafile Helm chart is provided by [datamate](https://datamate.org), the primary support and sales partner in Europe.
> Currently this Helm Chart is still a Beta version. Only use this if you are familiar with Kubernetes and Helm

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Cluster with at least 4GB of free RAM

### Create a Namespace

```bash
kubectl create namespace seafile
```

### Create a Secret for Your License

**Note:** If you don't have a license, create an empty `seafile-license.txt` file. This will allow you to try out Seafile (3 users max).

```bash
kubectl create secret generic seafile-license --from-file=seafile-license.txt=$PATH_TO_YOUR_LICENSE_FILE --namespace seafile
```

### Deploy an Ingress Controller (ingress-nginx)

```bash
helm upgrade --install ingress-nginx ingress-nginx \
  --repo https://kubernetes.github.io/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

Please refer to the [ingress-nginx docs](https://kubernetes.github.io/ingress-nginx/deploy/#quick-start) for detailed instructions.

**Note:** There are environment/cloud-provider-specific instructions: https://kubernetes.github.io/ingress-nginx/deploy/#cloud-deployments (e.g. for DigitalOcean)

### DNS

Wait until your cloud provider has allocated an external IP address to the ingress controller:

```bash
kubectl get services -n ingress-nginx --watch
```

Once this is done, you can create your DNS record using this external IP address.

### TLS

1. Deploy cert-manager [using Helm](https://cert-manager.io/docs/installation/helm/)
1. Configure a [Let's Encrypt Issuer](https://cert-manager.io/docs/tutorials/acme/nginx-ingress/#step-6---configure-a-lets-encrypt-issuer) (inside the `seafile` namespace)
1. Note down the issuer resource name

**Note:**
On DigitalOcean (and many other cloud providers), ingress-nginx/the CCM provisions a load balancer which uses the `PROXY` protocol to send traffic
to the ingress controller. The advantage is that all headers (e.g. for the client IP) are preserved. However, this causes problems with cert-manager,
which first tries to initiate a self-check and does not support the proxy protocol ([#466](https://github.com/cert-manager/cert-manager/issues/466)).
ingress-nginx expects all requests to use this protocol.

There are a few possible workarounds:
1. Deploy [hairpin-proxy](https://github.com/webofmars/hairpin-proxy) which uses a custom controller to modify CoreDNS Corefiles:
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/webofmars/hairpin-proxy/v0.5.0/deploy.yml
    ```
2. Use an additional DNS record and custom annotations to work arounds this issue (e.g. [for DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nginx-ingress-with-cert-manager-on-digitalocean-kubernetes#step-5-enabling-pod-communication-through-the-load-balancer-optional))
3. Terminate TLS at the load balancer
4. Wait for [KEP 1860](https://github.com/kubernetes/enhancements/issues/1860), which should hopefully fix this issue

## Installing the Chart

Create a custom values file:

```bash
touch my-values.yaml
```

Make configuration changes:

```yaml
seafileConfig:
  # Enter your hostname
  hostname: ""
```

To install the chart use the following:

```console
helm repo add datamate https://datamate-rethink-it.github.io/seafile-helm
helm upgrade --install seafile datamate/seafile --namespace seafile --create-namespace --values my-values.yaml
```

## Uninstalling the Chart

If you use the included mariadb-galera chart, you need to scale the _StatefulSet_ down before removing all the pods. Otherwise the database cluster won't be able to start up again without making tedious configuration changes.

```bash
kubectl scale sts $RELEASE-mariadb-galera --namespace seafile --replicas=0
```

Please refer to the mariadb-galera docs for more details ([#1](https://artifacthub.io/packages/helm/bitnami/mariadb-galera#uninstalling-the-chart), [#2](https://artifacthub.io/packages/helm/bitnami/mariadb-galera#bootstraping-a-node-other-than-0)).

---

To remove the chart again use the following:

```console
helm delete seafile --namespace seafile
```

## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](./values.yaml), or run this configuration command:

```console
helm show values datamate/seafile
```

### Seahub Customization

Use the following commands if you want to customize Seahub:

1. Create a config map for your custom logo, login background image and favicon:
    ```bash
    kubectl create configmap seafile-customization --namespace seafile \
      --from-file=mylogo.png=$PATH_TO_YOUR_LOGO \
      --from-file=login-bg.jpg=$PATH_TO_YOUR_LOGIN_BG \
      --from-file=favicon.ico=$PATH_TO_YOUR_FAVICON
    ```

2. Set `seafileConfig.seahub.customizationConfigmap` to `seafile-customization` and upgrade your deployment
