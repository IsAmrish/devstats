#!/bin/bash
function finish {
    sync_unlock.sh
}
if [ -z "$TRAP" ]
then
  sync_lock.sh || exit -1
  trap finish EXIT
  export TRAP=1
fi
./grafana/influxdb_recreate.sh opa_temp || exit 1
GHA2DB_LOCAL=1 GHA2DB_PROJECT=opa IDB_DB=opa_temp ./idb_vars || exit 2
GHA2DB_CMDDEBUG=1 GHA2DB_RESETIDB=1 GHA2DB_LOCAL=1 GHA2DB_PROJECT=opa PG_DB=opa IDB_DB=opa_temp ./gha2db_sync || exit 3
./grafana/influxdb_recreate.sh opa || exit 4
IDB_DB_SRC=opa_temp IDB_DB_DST=opa ./idb_backup || exit 5
./grafana/influxdb_drop.sh opa_temp