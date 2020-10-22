FROM golang:1.15.2-buster

RUN apt-get update && apt-get install -y unzip

ARG TERRAFORM_VERSION=0.13.4
RUN curl -L -so /tmp/terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip /tmp/terraform.zip -d /usr/local/bin/
