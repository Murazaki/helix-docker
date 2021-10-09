FROM ubuntu:focal

LABEL vendor="Perforce Software"
LABEL maintainer="Paul Allen (pallen@perforce.com)"

# Update Ubuntu and add Perforce Package Source
RUN \
  apt-get update && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y wget unzip gnupg netcat lsb-core net-tools rsyslog && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y openjdk-8-jdk && \
  wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add - && \
  echo "deb http://package.perforce.com/apt/ubuntu focal release" > /etc/apt/sources.list.d/perforce.list && \
  apt-get update
  
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y helix-cli

ADD http://ftp.perforce.com/perforce/r16.1/bin.java/p4search.tgz /p4search.tgz 

RUN tar xfz /p4search.tgz

## TODO - add triggers:
#  SEARCH.change    form-commit   change "%//depot/p4search/install/search-queue.sh% -t change   -v %formname%"
#  SEARCH.commit    change-commit //...  "%//depot/p4search/install/search-queue.sh% -t commit   -v %change%"