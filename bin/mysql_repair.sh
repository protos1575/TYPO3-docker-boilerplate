#!/usr/bin/env bash#

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

source "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.config.sh"

if [[ -n "$(dockerContainerId mysql)" ]]; then
    MYSQL_ROOT_PASSWORD=$(dockerExecMySQL printenv MYSQL_ROOT_PASSWORD)
    dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\" mysqlcheck -h mysql -uroot --all-databases --check-upgrade --auto-repair"
    dockerExecMySQL sh -c "MYSQL_PWD=\"${MYSQL_ROOT_PASSWORD}\"  mysql_upgrade -uroot"
    logMsg "MYSQ repaired"
fi