# Install Istio on an existing Kubernetes cluster

Please follow the installation instructions from [istio.io](https://istio.io/docs/tasks/installing-istio.html).

## Directory structure
This directory contains files needed for installing Istio on a Kubernetes cluster.

* istio-rbac.yaml - apply this file in the begining to an RBAC enabled cluster
* istio.yaml - use this file for installation without authentication enabled
* istio-auth.yaml - use this file for installation with authentication enabled
* templates - directory contains the templates used to generate istio.yaml and istio-auth.yaml
* addons - directory contains optional components (Prometheus, Grafana, Service Graph)
