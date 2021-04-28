![Release Draft On Master](https://github.com/kruzio/kube-dialer/workflows/Release%20Draft%20On%20Master/badge.svg)

# kube-dialer
Cluster Applications (Services) Single Page Dialer


## Why kube-dialer
A single page web application (SPA) with shortcuts (external links) genearted from ConfigMap

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
