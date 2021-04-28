FROM alpine:latest

ENV HUGO_VERSION 0.65.1


# Install HUGO
RUN set -x && \
  apk add --update bash wget ca-certificates && \
  wget https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  tar vxzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
  mv hugo /usr/bin/hugo 
  

RUN apk del wget ca-certificates && \
  rm /var/cache/apk/*

COPY dialer/site /www  

#ENTRYPOINT ["bash -c"]
CMD ["hugo","server", "--bind", "0.0.0.0", "-p", "80","-s", "/www"]