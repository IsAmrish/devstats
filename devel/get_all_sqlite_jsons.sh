#!/bin/bash
if [ -z "$ONLY" ]
then
  host=`hostname`
  if [ $host = "cncftest.io" ]
  then
    all=`cat ./devel/all_test_projects.txt`
  else
    all=`cat ./devel/all_prod_projects.txt`
  fi
else
  all=$ONLY
fi
for proj in $all
do
    db=$proj
    if [ "$proj" = "kubernetes" ]
    then
      db="k8s"
    fi
    echo "Project: $proj, GrafanaDB: $db"
    rm -f sqlite/* 2>/dev/null
    ./sqlitedb /var/lib/grafana.$db/grafana.db || exit 1
    rm -f grafana/dashboards/$proj/*.json || exit 2
    mv sqlite/*.json grafana/dashboards/$proj/ || exit 3
done
echo 'OK'
