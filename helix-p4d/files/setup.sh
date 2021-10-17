#!/bin/bash

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    local varValue=$(env | grep -E "^${var}=" | sed -E -e "s/^${var}=//")
    local fileVarValue=$(env | grep -E "^${fileVar}=" | sed -E -e "s/^${fileVar}=//")
    if [ -n "${varValue}" ] && [ -n "${fileVarValue}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    if [ -n "${varValue}" ]; then
        export "$var"="${varValue}"
    elif [ -n "${fileVarValue}" ]; then
        export "$var"="$(cat "${fileVarValue}")"
    elif [ -n "${def}" ]; then
        export "$var"="$def"
    fi
    unset "$fileVar"
}

file_env P4USER
file_env P4PASSWD

set -x

# Start server in Unicode mode
p4d $P4CASE -r$P4ROOT -p$P4TCP -L$P4LOG -J$P4JOURNAL -xi
p4d $P4CASE -r$P4ROOT -p$P4TCP -L$P4LOG -J$P4JOURNAL -d

set +x
echo -e "${P4PASSWD}\n${P4PASSWD}\n" | p4 passwd ${P4USER}
echo -e "${P4PASSWD}\n${P4PASSWD}\n${P4PASSWD}\n" | p4 passwd ${P4USER}
echo $P4PASSWD > pass.txt
set -x

p4 -u ${P4USER} login < pass.txt
rm pass.txt

## Create super user and protection
p4 configure set $P4NAME#security=$SECURITY
p4 configure set $P4NAME#server.depot.root=$P4DEPOTS
p4 configure set $P4NAME#journalPrefix=$P4CKP/$JNL_PREFIX
p4 configure set $P4NAME#server.allowfetch=3
p4 configure set $P4NAME#server.allowpush=3
p4 configure set $P4NAME#server.allowremotelocking=1
p4 configure set $P4NAME#server.allowrewrite=1
p4 configure set $P4NAME#server.commandlimits=2
p4 user -o | p4 user -i
p4 protect -o | p4 protect -i
