
.SECONDARY:
.SECONDEXPANSION:


.phony: help tutorials

create-kind-cluster:  ##@Test creatte KIND cluster
	kind create cluster --config hack/kind-config.yaml --image kindest/node:v1.16.9 --name kruztest

delete-kind-cluster:  ##@Test delete KIND cluster
	kind delete cluster --name kruztest

#
# Install NGINX Ingress for KIND
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
#
helm-install:   ##@Test Run site locally on Kubernetes
	kubectl create ns kubedialer || true
	helm upgrade -i kubedialer deploy/charts/dialer -n kubedialer	

helm-uninstall: ##@Test Remove the helm chart
	helm delete -n kubedialer kubedialer	

INSTALL_OUTDIR=deploy/install
generate-k8s-yaml:	##@Generate Generate k8s installation file
	helm template kubedialer deploy/charts/dialer  > $(INSTALL_OUTDIR)/kubedialer.yaml


kruz-get-mac-deps: ##@PreBuild Dependencies Linux
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.59.1/hugo_extended_0.59.1_macOS-64bit.tar.gz
	tar -xf hugo_extended_0.59.1_linux-64bit.tar.gz hugo
	sudo mv hugo /usr/local/bin/hugo

kruz-get-linux-deps: ##@PreBuild Dependencies MacOS		
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.59.1/hugo_extended_0.59.1_Linux-64bit.tar.gz
	tar -xf hugo_extended_0.59.1_Linux-64bit.tar.gz
	sudo mv hugo /usr/local/bin/hugo

VERSION ?= 1.0.0
DOCKER_IMAGE ?= 	
DOCKER_VERSION_REV = `git rev-parse --short HEAD`
DOCKER_TAG=$(VERSION)-$(DOCKER_VERSION_REV)

kube-dialer-build-image: ##@Build Build kube-dialer image
	cd dialer && docker build \
	  --build-arg VCS_REF=`git rev-parse --short HEAD` \
	  --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	  -t $(DOCKER_IMAGE):$(DOCKER_TAG) . 
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest


kube-dialer-artifacts: ##@Build Publish kube-dialer image
	mkdir artifacts | true
	zip -r artifacts/kube-dialer-chart.zip deploy/charts

kube-dialer-publish-image: ##@Build Publish kube-dialer image
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)	

kube-dialer-serve:   ##@Local Run site locally    
	cd $(CURDIR)/dialer/site && hugo serve -D --noHTTPCache

kube-dialer-dockerun:   ##@Local Run site locally
	docker run --rm  --net=host --name=kube-dialer  $(DOCKER_IMAGE):$(DOCKER_TAG)

HELP_FUN = \
         %help; \
         while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^(.+)\s*:.*\#\#(?:@(\w+))?\s(.*)$$/ }; \
         print "Usage: make [options] [target] ...\n\n"; \
     for (sort keys %help) { \
         print "$$_:\n"; \
         for (sort { $$a->[0] cmp $$b->[0] } @{$$help{$$_}}) { \
             $$sep = " " x (30 - length $$_->[0]); \
             print "  $$_->[0]$$sep$$_->[1]\n" ; \
         } print "\n"; }



help: ##@Misc Show this help
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)	

.DEFAULT_GOAL := help

USERID=$(shell id -u)	