# --------------------------------------------------------------------------------
# Docker configuration for Swarm
# --------------------------------------------------------------------------------

FROM ubuntu:focal

LABEL vendor="Perforce Software"
LABEL maintainer="Mehdi Benadel (mehdi.benadel@gmail.com)"

# Update Ubuntu and add Perforce Package Source
RUN \
  apt-get update  && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y wget curl unzip gnupg && \
  wget -qO - https://package.perforce.com/perforce.pubkey | apt-key add - && \
  echo "deb http://package.perforce.com/apt/ubuntu focal release" > /etc/apt/sources.list.d/perforce.list && \
  apt-get update

# Create swarm user and install Helix Swarm
RUN \
  useradd --user-group --home-dir /home/swarm --create-home --uid 1000 swarm && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y helix-cli && \
  DEBIAN_FRONTEND="noninteractive" apt-get install -y -f helix-swarm

# --------------------------------------------------------------------------------
# Docker ENVIRONMENT
# --------------------------------------------------------------------------------

# Default Environment
ARG P4PORT
ARG P4USER
ARG P4PASSWD
ARG SWARMHOST
ARG SWARMUSER
ARG SWARMPASSWD
ARG SWARMTOKEN
ARG REDISPASSWORD
ARG MAILHOST
ARG BASE_URL

# Configure Swarm Environment
ENV P4PORT=$P4PORT \
  P4USER=$P4USER \
  P4PASSWD=$P4PASSWD \
  SWARMHOST=$SWARMHOST \
  SWARMUSER=$SWARMUSER \
  SWARMPASSWD=$SWARMPASSWD \
  SWARMTOKEN=$SWARMTOKEN \
  REDISPASSWORD=$REDISPASSWORD \
  MAILHOST=$MAILHOST \
  BASE_URL=$BASE_URL

EXPOSE 80

# Add external files
COPY files/setup.sh /opt/perforce/swarm/setup.sh
COPY files/config.php /opt/perforce/swarm/data/config.php

# Configure Apache/Swarm
RUN \
	chmod +x /opt/perforce/swarm/setup.sh && \
	chown -R www-data:www-data /opt/perforce/swarm/data && \
	a2dissite 000-default && \
	mkdir -p /opt/perforce/swarm/data/queue/tokens && \
	touch /opt/perforce/swarm/data/queue/tokens/$SWARMTOKEN

# --------------------------------------------------------------------------------
# Docker RUN
# --------------------------------------------------------------------------------

USER root
ENTRYPOINT \
        until p4 info -s 2> /dev/null; do sleep 1; done && \
	echo "Perforce Server [FOUND]" && \
	until p4 -p p4d.helix:1666 info -s 2> /dev/null; do sleep 1; done && \
	echo "Build Server [FOUND]" && \
	cron start && \
	/opt/perforce/swarm/setup.sh && \
  while [ ! -f /opt/perforce/swarm/data/log ]; do sleep 1; done && \
  tail -f /opt/perforce/swarm/data/log

HEALTHCHECK \
	--interval=2m \
	--timeout=10s \
	CMD curl --fail http://localhost/api/version || exit 1
