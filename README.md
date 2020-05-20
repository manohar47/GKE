# Project Title

Wordpress on GCP

### Prerequisites

- Google Kuberntes Engine
- CloudSQL 
- Terraform

### Setting up the environment

Deploy the GKE cluster and cloudSQL instance in GCP as per the configuration defined inside the terraform files 

Following are the terraform commands that need to be executed

```
Terraform init 
Terraform fmt
Terraform validate
Terraform plan 
Terraform apply
```

### Configure GKE with the necessary kubernetes objects and resources inorder to spin up the Wordpress Blog

Create PersistentVolume and PersistentVolumeClaim to facilitate storage for blog related objects and data

```
kubectl apply -f gke/wordpress-volumeclaim.yaml
```

Create Service account for cloudsql proxy and add the cloudsql client role to the SA inorder to allow WordPress app to access the MySQL instance through Cloud SQL proxy

```
gcloud iam service-accounts create cloudsql-proxy --display-name $SA_NAME

gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
    --role roles/cloudsql.client \
    --member serviceAccount:cloudsql-proxy
```
##Create the service account key for cloudsql-proxy SA

```
gcloud iam service-accounts keys create ./key.json \
    --iam-account cloudsql-proxy
```

### Configure kubernetes secrets to inject mysql credentials and service account credentials into the wordpress Deployment

```
kubectl create secret generic cloudsql-db-credentials \
    --from-literal username=default \
    --from-literal password=default

kubectl create secret generic cloudsql-instance-credentials \
    --from-file ./key.json
```

### Configure the deployment file by replacing the environment variables

```
cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > \
    $WORKING_DIR/wordpress_cloudsql.yaml
```

Deploy the manifest file

```
kubectl create -f $WORKING_DIR/wordpress_cloudsql.yaml
```

### Create a wordpress service inorder to expose the deployed wordpress app to the outside internet traffic

```
kubectl create -f $WORKING_DIR/wordpress-service.yaml
```

## Wordpress Blog URL 

* (http://35.236.5.106)

Add additional notes about how to deploy this on a live system

## Referance Documnetation

* [Terraform-cloudsql](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html) 
* [Terraform-GKE](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
* [cloud_sql_proxy](https://cloud.google.com/sql/docs/mysql/connect-kubernetes-engine)


