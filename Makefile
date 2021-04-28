
.SECONDARY:
.SECONDEXPANSION:

GORELEASER_VERSION := 0.145.0
GORELEASER := $(CURDIR)/bin/goreleaser

.phony: help tutorials

create-kind-cluster:  ##@Test creatte KIND cluster
	kind create cluster --config hack/kind-config.yaml --image kindest/node:v1.18.2 --name kruztest

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


kruz-get-mac-deps: ##@PreBuild Dependencies MacOS
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.59.1/hugo_extended_0.59.1_macOS-64bit.tar.gz
	tar -xf hugo_extended_0.59.1_linux-64bit.tar.gz hugo
	sudo mv hugo /usr/local/bin/hugo

kruz-get-linux-deps: get-release-bins ##@PreBuild Dependencies Linux		
	curl -LO https://github.com/gohugoio/hugo/releases/download/v0.59.1/hugo_extended_0.59.1_Linux-64bit.tar.gz
	tar -xf hugo_extended_0.59.1_Linux-64bit.tar.gz
	sudo mv hugo /usr/local/bin/hugo

get-release-bins: ##@PreBuild Dependencies Linux	
	mkdir -p $(CURDIR)/bin || echo "dir already exist" &&\
	cd $(CURDIR)/bin &&\
	wget https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_Linux_x86_64.tar.gz && \
	tar xvf goreleaser_Linux_x86_64.tar.gz &&\
	rm -Rf goreleaser_Linux_x86_64*	

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


kube-dialer-publish-image: ##@Build Publish kube-dialer image
	# Push to DockerHub
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)	

kube-dialer-serve:   ##@Local Run site locally    
	cd $(CURDIR)/dialer/site && hugo serve -D --noHTTPCache

kube-dialer-dockerun:   ##@Local Run site locally
	docker run --rm  --net=host --name=kube-dialer  $(DOCKER_IMAGE):$(DOCKER_TAG)

#
#  How to release:
#
#  1. Grab GITHUB Token of kruzbuilder from 1password
#  2. export GITHUB_TOKEN=<thetoken>
#  3. git tag -a v0.4.0 -m "my new version"
#  4. git push origin v0.4.0
#  5. Go to to https://github.com/kruzio/kube-dialer/releases and publish the release draft
#
#  Delete tag: git push origin --delete v0.7.0
#
helm-release:  ##@release create helm chart archive
	mkdir artifacts | true
	zip -r artifacts/kube-dialer-chart.zip deploy/charts

.PHONY: gorelease
gorelease: helm-release ##@release Generate All release artifacts
	GOPATH=~ USER=kruzbuilder $(GORELEASER) -f $(CURDIR)/.goreleaser.yml --rm-dist --release-notes=notes.md

gorelease-snapshot: helm-release ##@release Generate All release artifacts
	GOPATH=~ USER=kruzbuilder  GORELEASER_CURRENT_TAG=v0.0.0 $(GORELEASER) -f $(CURDIR)/.goreleaser.yml --rm-dist --skip-publish --snapshot


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