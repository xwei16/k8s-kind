kind create cluster --name app-1-cluster --config kind-single-node.yaml
# Verify cluster networking
kubectl get pods -n kube-system

kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/9.5.0-2.2.6/deploy/deploy-crds.yaml
kubectl apply -f https://raw.githubusercontent.com/mysql/mysql-operator/9.5.0-2.2.6/deploy/deploy-operator.yaml
kubectl get deployment -n mysql-operator mysql-operator
kubectl get pods -n mysql-operator -w
# debug:$> kubectl describe pod mysql-operator-6cf45cd6f7-9tt9j -n mysql-operator
# $> kubectl logs mysql-operator-6cf45cd6f7-9tt9j -n mysql-operator


kubectl create secret generic mypwds \
        --from-literal=rootUser=root \
        --from-literal=rootHost=% \
        --from-literal=rootPassword="sakila" \
        -n mysql-operator

kubectl apply -f innodbcluster.yaml
kubectl get pods -n mysql-operator -w

kubectl get service mycluster

kubectl run --rm -it myshell \
  --image=container-registry.oracle.com/mysql/community-operator \
  --namespace mysql-operator \
  -- mysqlsh root@mycluster.mysql-operator.svc.cluster.local:3306

# kubectl run --rm -it myshell --image=container-registry.oracle.com/mysql/community-operator -- mysqlsh
# kubectl exec -it mysql-operator-6bf8445fd7-cx4x5 -n mysql-operator -- mysql -uroot -p

#Results:

# All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
# If you don't see a command prompt, try pressing enter.
# Please provide the password for 'root@mycluster.mysql-operator.svc.cluster.local:3306': ******
# Save password for 'root@mycluster.mysql-operator.svc.cluster.local:3306'? [Y]es/[N]o/Ne[v]er (default No): yes
# MySQL Shell 9.5.0

# Copyright (c) 2016, 2025, Oracle and/or its affiliates.
# Oracle is a registered trademark of Oracle Corporation and/or its affiliates.
# Other names may be trademarks of their respective owners.

# Type '\help' or '\?' for help; '\quit' to exit.
# Creating a session to 'root@mycluster.mysql-operator.svc.cluster.local:3306'
# Fetching global names for auto-completion... Press ^C to stop.
# Your MySQL connection id is 0
# Server version: 9.5.0 MySQL Community Server - GPL
# No default schema selected; type \use <schema> to set one.
#  MySQL  mycluster SQL > SHOW DATABASES;
# +-------------------------------+
# | Database                      |
# +-------------------------------+
# | information_schema            |
# | mysql                         |
# | mysql_innodb_cluster_metadata |
# | performance_schema            |
# | sys                           |
# +-------------------------------+
# 5 rows in set (0.0026 sec)
#  MySQL  mycluster.mysql-operator.svc.cluster.local:3306 ssl  SQL > 