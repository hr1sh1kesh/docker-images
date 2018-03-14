#!/bin/sh

#set -x
echo "Initializing..."

svcname="portworx-service.kube-system.svc.cluster.local"

timeout=420

pxClusterStatus=$(curl -XGET http://$svcname:9001/v1/cluster/enumerate)
echo $pxClusterStatus

while [[ "$pxClusterStatus" = "" ]]
do
 if [[ $timeout == 0 ]]; then
    echo "PX Cluster hasnt come up yet. Please contact support@portworx.com"
    exit 1
 else
    echo "Waiting... looks like the px pods arent ready yet"
    sleep 1
    timeout=timeout-1
    pxClusterStatus=$(curl -XGET http://$svcname:9001/v1/cluster/enumerate)
 fi 
done

echo $pxClusterStatus