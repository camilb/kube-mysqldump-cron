## Features

  * dump and import a single or multiple databases
  * dump each database into a different file
  * exclude a database from dump
  * Kubernetes scheduled jobs examples for automatic backup, copy and import databases

## Usage :

### Using Docker only

#### Dump a database to the current directory

    docker run --rm -v $PWD:/mysqldump -e DB_NAME=db_name -e DB_PASS=db_pass -e DB_USER=db_user -e DB_HOST=db_host camil/mysqldump

#### Dump all databases to the current directory

    docker run --rm -v $PWD:/mysqldump -e DB_PASS=db_pass -e DB_USER=db_user -e DB_HOST=db_host -e ALL_DATABASES=true camil/mysqldump

#### Exclude one database from dump

    docker run --rm -v $PWD:/mysqldump -e DB_PASS=db_pass -e DB_USER=db_user -e DB_HOST=db_host -e ALL_DATABASES=true -e IGNORE_DATABASE=some_database camil/mysqldump

#### Import one database from the current directory

    docker run --rm -v $PWD:/mysqldump --entrypoint /import.sh -e DB_NAME=db_name -e DB_HOST=db_host -e DB_USER=db_user -e DB_PASS=db_pass camil/mysqldump

#### Import all the databases from the current directory

    docker run --rm -v $PWD:/mysqldump --entrypoint /import.sh -e DB_NAME=db_name -e DB_HOST=db_host -e DB_USER=db_user -e DB_PASS=db_pass -e ALL_DATABASES=true camil/mysqldump

### Kubernetes scheduled jobs

Notes:

  * you have to label a node with `role=mysqldump` on the source cluster and `role=mysqlimport` on the destination cluster. Or just remove the `nodeSelector`rules from jobs.
  * Edit ConfigMaps and Secrets according to your environment. Values in secrets have to be base64 encoded.
  * Edit the `scheduledjobs` definitions to set backup location or change the linux user:

#### Backup one or more databases

1. If you plan to dump just some databases, use or duplicate the "mysqldump.scheduledjob.single.yaml" example

2. To dump all databases use "mysqldump.scheduledjob.all.yaml" example. Also has an option to exclude one database from backup.

3. Create secret, configmap and job(s)

	     kubectl create -f k8s/mysqldump/mysqldump.configmap.yaml
	     kubectl create -f k8s/mysqldump/mysqldump.secret.yaml
	     kubectl create -f k8s/mysqldump/mysqldump.scheduledjob.all.yaml

#### Automatic transfer the backups to another kubernetes cluster or external server

       kubectl create -f k8s/mysqldump/transporter.configmap.yaml
       kubectl create -f k8s/mysqldump/transporter.secret.yaml
       kubectl create -f k8s/mysqldump/transporter.scheduledjob.yaml

#### Automatic import the backup on different cluster

      kubectl create -f k8s/mysqlimport/mysqlimport.configmap.yaml
      kubectl create -f k8s/mysqlimport/mysqlimport.secret.yaml
      kubectl create -f k8s/mysqlimport/mysqlimport.scheduledjob.yaml
