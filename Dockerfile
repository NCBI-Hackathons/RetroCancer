FROM ubuntu:latest

MAINTAINER Kishore R. Anekalla "kishorereddyanekalla@gmail.com"

RUN apt-get update
RUN apt-get -y install r-base
RUN apt-get -y install libcurl4-gnutls-dev
RUN apt-get -y install libssl-dev

#
COPY scripts/quantification.sh /

CMD ["bash", "scripts/quantification.sh"]
