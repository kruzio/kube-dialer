![release](https://img.shields.io/github/v/release/kruzio/kube-dialer?sort=semver)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
![Tweet](https://img.shields.io/twitter/url?style=social&url=https%3A%2F%2Fgithub.com%2Fkruzio%2Fkube-dialer)

# kube-dialer
Cluster Applications (Services) Single Page Dialer behind OAuth2 authentication


## Why kube-dialer
No Code, single page web application (SPA) with shortcuts (external links) genearted from ConfigMap

## Use Cases
* A dialer to cluster internal applications.
* An engineering bookmark jump page.


## Run Locally

1. Create KIND Cluster
```bash
make create-cluster
```

2. Install NGINX Ingress COntroller
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
```

3. Add to your /etc/hosts file:
```bash
127.0.0.1	kubedialer.kruz.io
```

4. Install kube dialer
```bash
make helm-install
```

## Installation

With Helm 3 run:

```bash
helm install --namespace kube-dialer kube-dialer deploy/charts/dialer
```

## Cleanup

```bash
helm delete --namespace kube-dialer kube-dialer
```

And

```bash
kubectl delete ns kube-dialer
```
