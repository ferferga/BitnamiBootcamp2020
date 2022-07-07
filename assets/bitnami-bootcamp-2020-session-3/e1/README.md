Excersise 1
-----------

Deployment order:

1. Namespace
2. ConfigMap
3. Secrets
4. MariaDB Deployment
5. MariaDB Service
6. Wordpress Deployment
7. Wordpress Service

NOTE: Both deployments contains a Liveness & Readiness probe with a default initial delay of 60 seconds,
so maybe it will need some time before showing the pod marked as Ready and Healthy.

Commands
```
kubectl apply -f ns.yaml

kubectl apply -f ./e1
```

Canary Deployment

1. First step is to deploy the new version that we want to upgrade
```
kubectl apply -f  wordpress-deployment-canary.yaml
```

2. After this, we will have a new container called wordpress2-xxxxx with the new version running
```
NAME                          READY   STATUS    RESTARTS   AGE
mariadb-55554976-8klvw        1/1     Running   0          28m
wordpress-5ccf7b59f5-2cjgg    1/1     Running   0          28m
wordpress-5ccf7b59f5-f8869    1/1     Running   0          18m
wordpress2-84b7b75d9b-rnsgh   1/1     Running   0          101s
```

3. As soon as we can confirm that the new container is working properly, we will proceed to delete this deployment
```
kubectl delete deployment wordpress2
```

4. And after this we will proceed to update the image of the deployment
```
kubectl set image deploy/wordpress wordpress=wordpress:5.3.2 --record
deployment.apps/wordpress image updated
```
After this, a new container with this image will be created and as soon as this is up and running, the previous ones
will be destroyed by kubernetes
```
NAME                         READY   STATUS              RESTARTS   AGE
mariadb-55554976-8klvw       1/1     Running             0          31m
wordpress-5ccf7b59f5-2cjgg   1/1     Running             0          31m
wordpress-5ccf7b59f5-f8869   1/1     Running             0          21m
wordpress-6bbcd767df-hww64   0/1     ContainerCreating   0          3s
```
