#!/bin/bash
set -x

sed -i "s|%SWARMHOST%|$SWARMHOST|g" /opt/perforce/swarm/data/config.php
sed -i "s|%P4PORT%|$P4PORT|g" /opt/perforce/swarm/data/config.php
sed -i "s|%SWARMUSER%|$SWARMUSER|g" /opt/perforce/swarm/data/config.php
sed -i "s|%SWARMPASSWORD%|$SWARMPASSWORD|g" /opt/perforce/swarm/data/config.php
sed -i "s|%REDISPASSWORD%|$REDISPASSWORD|g" /opt/perforce/swarm/data/config.php
sed -i "s|%MAILHOST%|$MAILHOST|g" /opt/perforce/swarm/data/config.php

set +x
echo -e "
/opt/perforce/swarm/sbin/configure-swarm.sh --non-interactive \\
    --p4port ${P4PORT} \\
    --swarm-user ${SWARMUSER} --swarm-passwd (redacted) \\
    --swarm-host ${SWARMHOST} --email-host ${MAILHOST} \\
    --base-url ${BASE_URL} \\
    --create --create-group --force \\
    --super-user ${P4USER} --super-passwd (redacted)
"
/opt/perforce/swarm/sbin/configure-swarm.sh --non-interactive \
    --p4port ${P4PORT} \
    --swarm-user ${SWARMUSER} --swarm-passwd ${SWARMPASSWD} \
    --swarm-host ${SWARMHOST} --email-host ${MAILHOST} \
    # --base-url ${BASE_URL} \
    --create --create-group --force \
    --super-user ${P4USER} --super-passwd ${P4PASSWD}

## Login
echo $P4PASSWD > pass.txt
set -x
p4 login < pass.txt
rm pass.txt

## Add Swarm user to protections
p4 protect -o > /$P4HOME/protect.p4s
grep -q -F 'super user ${SWARMUSER}' /$P4HOME/protect.p4s
if [ $? -ne 0 ]; then
	echo "Adding Swarm user to protection table"
	echo -e "\tadmin user ${SWARMUSER} * //..." >> /$P4HOME/protect.p4s
	p4 protect -i < /$P4HOME/protect.p4s
fi

## Remove URL property and set to external docker localhost URL
p4 property -d -n P4.Swarm.URL -s 0
p4 property -a -n P4.Swarm.URL -v $BASE_URL


echo "Swarm setup finished."