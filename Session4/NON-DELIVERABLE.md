### Exercise 1
**Find the way to create a job with kubectl**

We can create our own cron jobs without using a YAML specification file with the following command:

``kubectl run hello --schedule="*/1 * * * *" --restart=OnFailure --image=busybox -- /bin/sh -c "date; echo Hello from the Kubernetes cluster``

``hello`` is how we're going to call our newly created job

``--schedule`` specifies when our job will run

``--restart`` will specify the restart policy of the job if it doesn't complete (i.e exits with 0 code).

``--image`` argument specifies the image that the pods spawned by the job for running the task will use.

``--`` after this argument, we pass the command line order that we want to execute periodically.

Here is a sample specification file, taken from the Kubernetes' documentation:
````
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
````
### Exercise 2
**Find information about the CronJob object. Use it in a example**

A CronJob is an object that can run one or multiple jobs regularly. For a better understanding of the concept, we can say that *CronJob* objects are
the equivalent to crontab in Linux systems and *Job* objects are each of the lines that are written in those crontabs.

The syntax for creating it using the command line is exactly the same as we explained before (in fact, we're creating a *CronJob* object
instead of a *Job* object in that example, jobs can only be created in a spec file). Here is a sample definition of a *CronJob*:

`````
apiVersion: batch/v1beta1
    kind: CronJob
    metadata:
      name: hello
    spec:
      schedule: "*/1 * * * *"
      jobTemplate:
        spec:
          template:
            spec:
              containers:
              - name: hello
                image: busybox
                args:
                - /bin/sh
                - -c
                - date; echo "Hello, World!"
              restartPolicy: OnFailure
`````

As we can see, each of the keys that are valid in the specifications of a *Job* object are also valid under the **jobTemplate** key,
which allows us to define the multiple jobs that we want to run under that *CronJob*.

### Exercise 3
**Find information about the StatefulSet object. Show examples with differences between the Deployment object**

This object does exactly the same as a Deployment. The major difference is that *StatefulSet* keep an unique identity for each of
the pods that are contained. If the *Statefulset* is recreated after a removal, the Pods will reuse their old identifier and other resources.
*StatefulSets* are the way to go when we want a predictable and organised deployment, as it allows a greater control in the order where Pods
are deployed. 

However, they need a **headless service** that manages the identity of each pod.

### Exercise 4
**Find the way to disable Minikube dynamic volume provisioner and try deploying PV and PVCs using the manual way**

With **minikube addons list** we can see a list of all the installed addons and if they're enabled or not. For disabling the addon,
we just need to run **minikube addons disable storage-provisioner** in our minikube host.

Here is a sample specification of a **PersistentVolume** object:

````
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv0003
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Recycle
  storageClassName: slow
````
Here is a sample specification of a **PersistentVolumeClaim** object:
````
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: myclaim
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
  storageClassName: slow
  selector:
    matchLabels:
      release: "stable"
````

### Exercise 5
**Try deploying the *GlusterFS Storage System* in your Minikube cluster**

The [repository](https://github.com/gluster/gluster-kubernetes) that was provided in the docs already includes a bash
script that deploys GlusterFS properly in our cluster. We can make the installation in one line:

``curl https://raw.githubusercontent.com/gluster/gluster-kubernetes/master/deploy/gk-deploy-minikube | sudo bash -``

### Exercise 6
**Once you have a chart deployed, find the way to get again the NOTES message that appears when deploying**

We can see it again using ``helm status <Chart's name>``

### Exercise 7
**Find the way to create your own helm chart repository**

A chart repository is an HTTP server that contains an ``index.yaml``. A sample folder structure will be as follows:

````
charts/
  |
  |- index.yaml
  |
  |- alpine-0.1.2.tgz
  |
  |- alpine-0.1.2.tgz.prov
````

The index must contain the download link of each of the charts and a description of them. Here is an example:

````
apiVersion: v1
entries:
  alpine:
    - created: 2016-10-06T16:23:20.499814565-06:00
      description: Deploy a basic Alpine Linux pod
      digest: 99c76e403d752c84ead610644d4b1c2f2b453a74b921f422b9dcb8a7c8b559cd
      home: https://helm.sh/helm
      name: alpine
      sources:
      - https://github.com/helm/helm
      urls:
      - https://example.com/alpine-0.2.0.tgz
      version: 0.2.0
    - created: 2016-10-06T16:23:20.499543808-06:00
      description: Deploy a basic Alpine Linux pod
      digest: 515c58e5f79d8b2913a10cb400ebb6fa9c77fe813287afbacf1a0b897cd78727
      home: https://helm.sh/helm
      name: alpine
      sources:
      - https://github.com/helm/helm
      urls:
      - https://example.com/alpine-0.1.0.tgz
      version: 0.1.0
generated: 2016-10-06T16:23:20.499029981-06:00
````

We can easily create a chart and upload them to our reporitory using the following commands:

````
helm package docs/examples/alpine/
mkdir package-charts
mv alpine-0.1.0.tgz package-charts/
helm repo index package-charts --url https://example.com
````

The last command fetches the index of the given url and returns it but
including the package you just created, so it's really useful for updating 

### Exercise 8
**Find and install a helm plugin**

The installation of a plugin is done with the following line:

``helm plugin install https://example.com/plugin-url``

For example, if we want to install the **Helm Tiller** plugin:

``helm plugin install https://github.com/rimusz/helm-tiller``

### Exercise 9
**Find information about Helm tests. Try adding one to a chart**

Tests are a definition of **Job** objects for Kubernetes, and they are designed to test if an specific helm chart
is behaving as intended.

Here is a simple test that will check if an nginx helm is running:

```
apiVersion: batch/v1
kind: Job
metadata:
  name: "{{ .Release.Name }}-connectivity-test"
  annotations:
    "helm.sh/hook": test
spec:
  template:
    spec:
      containers:
      - name: main
        image: {{ .Values.image }}
        env:
        - name: WEBSERVER_HOST
          value: {{ template "nginx.fullname" . }}
        - name: WEBSERVER_PORT
          value: {{ template "nginx.port" . }}
        command: ["sh", "-c", "curl http://$WEBSERVER_HOST:$WEBSERVER_PORT"]
      restartPolicy: Never
```