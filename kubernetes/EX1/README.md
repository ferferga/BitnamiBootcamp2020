We are going to create a WordPress + MariaDB deployment. There is also
another deployment intended to work as a canary one.

## Structure

1. One deployment for each container: WP, MariaDB and WP Canary (in individual files)
2. One service for each deployment: WP, MariaDB and WP Canary (in individual files)
3. One configmap for general settings for the environment
4. One secret file with base64 encoded variables, for sensitive data, such as passwords and usernames
5. **120 seconds** for readiness checks.
6. Liveness checks each **10 seconds**

## How To

1. Clone this folder somewhere in your system where you have permissions.
2. ``cd`` to this directory
3. Run ``kubectl create -f .`` to deploy all the files at once.

If you don't want the canary deployment, remove the ``wp-deployment-canary.yaml`` and
``wp-svc-canary.yaml`` files.

Switch to the new namespace: ``kubectl config set-context --current --namespace=exercise1``

Finally: Forward the port 90 to your system: ``kubectl port-forward svc/wp-service 80:90``