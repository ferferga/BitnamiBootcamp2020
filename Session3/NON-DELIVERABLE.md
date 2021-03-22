### Exercise 1
**Find the equivalent kubectl command to
``docker run --rm --name mytest -ti bitnami/minideb bash``**

For running a command inside a container handled by Kubernetes we can use ``kubectl exec <name_of_container> bash``

### Exercise 2
**Find the way to copy files to containers in a pod**

We can copy files from the pod's container to our local system and viceversa:

*From pod to local system:*

``kubectl cp {{namespace}}/{{podname}}:path/to/directory /local/path``

*From local system to pod:*

``kubectl cp /local/path namespace/podname:path/to/directory``

### Exercise 3
**Find the way to, given a yaml file, show the difference to what is currently deployed**

We can use the ``kubectl diff`` command for that.

During the research for this answer, I also found a tool called ``kubediff`` which can be found in its [GitHub repository](https://github.com/weaveworks/kubediff)

### Exercise 4
**Find the way to set the environment variable 'MODE=production' in all of the running pods**

We need to add a label to the running container using ``kubectl label pods $(kubectl get pods -o name | sed -E 's/.*\///') --overwrite <ENV>=<ENV_VALUE>``

### Exercise 5
**Find the way to obtain the list of recent events that occurred in the cluster**

The events that happened in our cluster are displayed with the ``kubectl get events`` command.

### Exercise 6
**Enable the plugin freshpod. Find what it is for and try its features**

Freshpod restarts containers when their images are updated.

For installing freshpod, we need to run the ``minikube addons enable freshpod`` command. However, it's already installed and enabled in latest minikube binaries, as the one I had:

<p align="center">
  <img src="https://github.com/ferferga/BitnamiBootcamp2020/raw/master/Session3/images/freshpod_module.png">
</p>

### Exercise 7
**Find information about the API Object ConfigMap. What is the difference compared to Secrets? Use it in an example**

ConfigMap helps in the process of separating the configuration parameters of an image and the actual instance running in a container. This is really useful for portability.

We can use ``kubectl create configmap <map-name> <data-source>`` for creating it.
One type of data-source we used in the bootcamp's slides was ``--from-literal=password=root``

As we can see in [this answer from StackOverflow](https://stackoverflow.com/a/36925553) 
written by Paul Morie, the 32nd top contributor to Kubernetes and a famous contributor to other Kubernetes-related projects.

Briefly, both are key/value pairs, but secrets should be used for sensitive information, while ConfigMap should be used for other types of config.
Secrets are stored in base64 (which isn't that secure anyway) while ConfigMap are stored in plaintext.

Here is an example secret:
```
apiVersion: v1
data:
  secret: Qml0bmFtaSBpcyBhIHJlYWxseSBjb29sIHBsYWNl
kind: Secret
metadata:
  creationTimestamp: null
  name: my-secret
```
Here is an example configmap:
```
apiVersion: v1
data:
  config: Bitnami containers
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: game-config
```
As you can see, in the ``ConfigMap`` the information is exposed.

### Exercise 8
**Find information about the API Objects LimitRanges and ResourceQuotas. Use them in an example**

Both are objects used to control the resource usage of a Kubernetes cluster. Resource Quotas are more targeted towards managing the use of
resources in the cluster's namespaces, while the LimitRanges are geared
towards the administration of the resources that pods and containers
consume in a namespace.

The ``LimitRange`` can be deployed just like any yaml file. Here is an example provided in the Kubernetes documentation:

```
apiVersion: v1
kind: LimitRange
metadata:
  name: limit-mem-cpu-per-container
spec:
  limits:
  - max:
      cpu: "800m"
      memory: "1Gi"
    min:
      cpu: "100m"
      memory: "99Mi"
    default:
      cpu: "700m"
      memory: "900Mi"
    defaultRequest:
      cpu: "110m"
      memory: "111Mi"
    type: Container
```
This will apply the LimitRange to all containers in the namespace.

The ``ResourceQuotas`` object is much more advanced and allow us to apply different policies for containers instances than are having better performance than others, for example.

Here is a sample ``ResourceQuotas`` definition file, as stated in the Kubernetes documentation:
```
apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: pods-high
  spec:
    hard:
      cpu: "1000"
      memory: 200Gi
      pods: "10"
    scopeSelector:
      matchExpressions:
      - operator : In
        scopeName: PriorityClass
        values: ["high"]
```

### Exercise 9
**Try creating, modifying and deleting using curl instead of kubectl**

For deleting:
```
curl -X DELETE \
    -d @- \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    https://$ENDPOINT/api/v1/namespaces/$NAMESPACE/<object_to_delete.EXAMPLE:Pod>/$NAME
```

For modifying:
```
curl -k \
    -X PATCH \
    -d @- \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json-patch+json' \
    https://$ENDPOINT/api/v1/namespaces/$NAMESPACE/<object_to_modify.EXAMPLE:Pod>/$NAME <<'EOF'
{
  New values to send as JSON
}
EOF
```

For creating:

```
curl -k \
    -X POST \
    -d @- \
    -H "Authorization: Bearer $TOKEN" \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    https://$ENDPOINT/api/v1/<object_to_create> <<'EOF'
{
  "kind": "Pod",  //Or the equivalent object
  "apiVersion": "v1",
  ...
}
EOF
```
