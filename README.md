# Seafile Helm Chart

[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/datamate)](https://artifacthub.io/packages/search?repo=datamate)
[![Release downloads](https://img.shields.io/github/downloads/datamate-rethink-it/seafile-helm/total.svg)](https://github.com/datamate-rethink-it/seafile-helm/releases)
[![Release Charts](https://github.com/datamate-rethink-it/seafile-helm/workflows/Release%20Charts/badge.svg)](https://github.com/datamate-rethink-it/seafile-helm/commits/main)

A [Helm](https://helm.sh) chart to install [Seafile](https://seafile.com), the open source file sync and share platform,
focusing on reliability and performance on [Kubernetes](https://kubernetes.io)

Please see [seafile/README.md](seafile/README.md) for detailed information & instructions.

## Sources

- [Helm chart sources](https://github.com/datamate-rethink-it/seafile-helm)
- [Helm repository source](https://github.com/datamate-rethink-it/seafile-helm/tree/gh-pages)
- [Helm releases](https://github.com/datamate-rething-it/seafile-helm/releases)

## Contributing

### Kubernetes Development Environment

You can use an environment provided by [hetznercloud/kubernetes-dev-env](https://github.com/hetznercloud/kubernetes-dev-env) or use your own.

#### Prerequisites

- [`k3sup`](https://github.com/alexellis/k3sup)
- [`tofu`](https://opentofu.org)

#### Instructions

```bash
git clone git@github.com:hetznercloud/kubernetes-dev-env.git

cd kubernetes-dev-env

# Token for Hetzner Cloud
export HCLOUD_TOKEN=''

# Edit example/main.tf and set `deploy_csi_driver` to `true`
# This is required in order to use volumes
nano example/main.tf

# Deploy the cluster
make -C example up

# Load environment variables into session (KUBECONFIG)
source example/files/env.sh
```

### Deploy Ingress Controller

Create `ingress-nginx-values.yaml`:

```yaml
controller:
  config:
    use-proxy-protocol: true
  service:
    annotations:
      # kubernetes-dev-env deploys the cluster into hel1 by default
      load-balancer.hetzner.cloud/location: "hel1"
      load-balancer.hetzner.cloud/uses-proxyprotocol: true
```

Deploy the controller:

```bash
helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx \
    --create-namespace \
    -f ingress-nginx-values.yaml
```

This will automatically provision a load balancer from Hetzner.
You should use the load balancer's public IP address to access any services deployed inside the cluster.

### Deploy Seafile

Please follow the instructions inside [seafile/README.md](./seafile/README.md).
