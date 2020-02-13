This docker compose will backup the database of the setup we previously did in **Deliverable 1** in a single command

## Instructions for using:

1. Run first the **Deliverable 1** docker-compose.yaml with ``docker-compose up`` in the directory where your compose is.

2. After doing that, run ``pwd | sed -E 's/.*\///'`` in your system (this will return the name of the directory you're located, but not its full path). 
Take the output of that command and replace ``ferferga`` (Line 14) from the ``networks`` block with the output you obtained
in **step 1**.

3. ``cd`` to the directory where you downloaded this ``docker-compose.yaml`` (it can't be in the same directory of the WP+Maria setup's docker-compose)

4. Create a ``database_backup`` folder and assign it permissions for everybody (``chmod -R 777 database_backup``)

5. Run ``docker-compose up``. After that command finishes, you will have a backup under the ``database_backup`` folder with the following format:

``all_backup-<TIMESTAMP>.sql``