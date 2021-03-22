We are going to create a WordPress + MariaDB deployment. There is also
another deployment intended to work as a canary one.

## Structure

1. One deployment for each container: WP, MariaDB and WP Canary (in individual files)
2. One service for each deployment: WP, MariaDB and WP Canary (in individual files)
3. One configmap for general settings for the environment
4. One secret file with base64 encoded variables, for sensitive data, such as passwords and usernames
5. **120 seconds** for readiness checks.
6. Liveness checks each **10 seconds**
7. Memory consumption is limited for each containers by Kubernetes to a 2048 maximum.

## How To

1. Clone this folder somewhere in your system where you have permissions.
2. ``cd`` to this directory
3. Run ``kubectl create -f .`` to deploy all the files at once.

Switch to the new namespace: ``kubectl config set-context --current --namespace=exercise2``

Finally: Forward the port 90 to your system: ``kubectl port-forward svc/wp-service 80:90``

PS: HyperDB plugin installation is still a WIP.