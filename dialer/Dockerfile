FROM alpine:latest
ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.name="kube-dialer" \
      org.label-schema.url="https://hub.docker.com/r/kruzio/kube-dialer/" \
      org.label-schema.vcs-url="https://github.com/kruzio/kube-dialer" \
      org.label-schema.build-date=$BUILD_DATE

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.17.0"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.0.2"

# RUN apk add --no-cache ca-certificates bash git openssh curl \
#     && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
#     && chmod +x /usr/local/bin/kubectl \
#     && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
#     && chmod +x /usr/local/bin/helm

ENV HUGO_VERSION 0.65.1

MAINTAINER devops@kruz.io

# Install HUGO
RUN set -x && \
  apk add --update bash wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  tar vxzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  mv hugo /usr/bin/hugo 
  

RUN apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY ./site /www  

#ENTRYPOINT ["bash -c"]
CMD ["hugo","server", "--bind", "0.0.0.0", "-p", "80","-s", "/www"]