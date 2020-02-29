![Release Draft On Master](https://github.com/kruzio/kube-dialer/workflows/Release%20Draft%20On%20Master/badge.svg)

# kube-dialer
Cluster Applications (Services) Single Page Dialer


## Why kube-dialer
A single page web application with shortcuts (external links) genearted from ConfigMap

## Use Cases
* A dialer to cluster internal applications.
* An engineering bookmark jump page.

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
