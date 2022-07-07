Excersise 2
-----------

First of all we must deploy all the containers we want to run, and after that we can copy the necessary files
to the wordpress container 

Deployment order:

1. Namespace
2. ConfigMap
3. Secrets
4. MariaDB Deployment (Master)
5. MariaDB Service
6. MariaDB Deployment (Slaves)
6. Wordpress Deployment
7. Wordpress Service

NOTE: Both deployments contains a Liveness & Readiness probe with a default initial delay of 60 seconds,
so maybe it will need some time before showing the pod marked as Ready and Healthy.

All the deployments have a 'spec' entry in order to keep the resources consumption under control

Commands
```
kubectl apply -f ns.yaml

kubectl apply -f mdb-master-cm.yaml 
kubectl apply -f mdb-slave-cm.yaml
kubectl apply -f wp-cm.yaml
 
kubectl apply -f wp-secrets.yaml 
kubectl apply -f mdb-secrets.yaml

kubectl apply -f mariadb-master-deployment.yaml
kubectl apply -f mariadb-svc.yaml

kubectl apply -f mariadb-slave-deployment.yaml

kubectl apply -f wordpress-deployment.yaml
kubectl apply -f wordpress-svc.yaml
```
WordPress Plugin Stage

For solving that we first must know the name of the pod that is hosting our wordpress application:
```
kubectl get pods | grep -i wordpress | awk -F " " '{ print $1 }'
```

this should response something like

```
wordpress-589444fd59-q22pk
```

In the same folder you have all the files for this exercise exists another folder that contains the plugin,
you must copy two files to the running container which name you got with the previous command, so the next step
is copying them into the pod using the following commands

```
kubectl cp hyperdb/db-config.php wordpress-589444fd59-q22pk:/opt/bitnami/wordpress/
kubectl cp hyperdb/db.php wordpress-589444fd59-q22pk:/bitnami/wordpress/wp-content/
```
NOTE: Bear in mind that wordpress-589444fd59-q22pk is the value of the running container I used in this explanation,
please replace it with yours in order to make the lines to work correctly.

With this last step, the plugin will be installed as described in the home page of it:
https://wordpress.org/plugins/hyperdb/#installation
