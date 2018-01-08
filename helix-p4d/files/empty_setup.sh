#!/bin/bash

## Create super user and protection
p4 configure set $P4NAME#server.depot.root=$P4DEPOTS
p4 configure set $P4NAME#journalPrefix=$P4CKP/$JNL_PREFIX
p4 user -o | p4 -p "$P4RSH" user -i
p4 protect -o | p4 -p "$P4RSH" protect -i
p4 passwd -P $P4PASSWD
p4 triggers -i < /opt/perforce/etc/triggers.p4s