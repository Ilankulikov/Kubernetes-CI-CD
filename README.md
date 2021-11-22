## Week 1<img src="https://user-images.githubusercontent.com/90269123/142770883-816223ed-3f85-47de-8ed0-5ae0c7b95e0d.png" width="22" height="21" alt="Computer Hope"> Project

# kubernetes 

__Deploying the Node Weight Tracker application on top of AKS cluster and automating the application lifecycle with a CI/CD process using Azure DevOps piplines.__



## Terraform
For this project we will need:
1. Azure Managed Kubernetes Service (AKS).
2. Azure Container Registry (ACR).
3. Azure Managed PostgreSQL Service.

__Create a "FILE_NAME.tfvars" file:__

>pg_user          = "Postgres SQL user name"<br/>
pg_database      = "Postgres SQL database name"<br/>
pg_password      = "Postgres SQL password"<br/>
cluster_name     = "AKS cluster name"<br/>
acr_name         = "ACR name"<br/>
rg_name          = "Resource group name"<br/>
env              = "Environment name"


To deploy the infrastructure follow these steps:
1. Clone the repository.
2. Run: 

        $ cd Kubernetes-CI-CD && cd terraform && terraform init
      
3. Run:
    
        $ terraform apply -var-file="FILE_NAME.tfvars" -auto-approve
        
Follow these steps before creating the pipeline:
1. Follow this [link](https://kubernetes.io/docs/tasks/tools/) to install `kubectl' on your agent.<br/>
1. Follow this [link](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt) to install Azure CLI on LINUX.<br/>
1. Follow this [link](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to login to Azure CLI.<br/>
1. Run the following command to get access credentials for a managed Kubernetes cluster.

        az aks get-credentials --name MyManagedCluster --resource-group MyResourceGroup
## Azure DevOps

Create an environment and connect it with AKS cluster that created with Terraform.

<img src="https://user-images.githubusercontent.com/90269123/142786127-2ec1c507-f333-4452-b1ab-ed8d869bdd17.png" width="400" height="500" alt="AKS">

Go to `Project settings` and create new service connection for Azure Container Registry that created with Terraform.

<img src="https://user-images.githubusercontent.com/90269123/142786303-641eed67-fe3c-4a4c-8d09-e4d4ce7bc116.png" width="400" height="500" alt="new service connection">

We now have two service connections one for AKS and another one for ACR:


<img src="https://user-images.githubusercontent.com/90269123/142786498-62233b89-171d-42d5-a873-b6c12d0cb2fc.png" width="800" height="200" alt="Service connection">

Now that we have the necessary service connections we can create a new pipline.
>For this project I have imported the repository to Azure Repos.

<img src="https://user-images.githubusercontent.com/90269123/142788065-5a6f3f96-1162-4790-a779-63bb3530420e.png" width="400" height="400" alt="new pipeline">

Click on `Use the classic editor` and choose the version control platform and the repository containing the azure-pipelines.yml .

<img src="https://user-images.githubusercontent.com/90269123/142788303-68ddda6e-4a44-468b-9724-26dca5b5faf4.png" width="700" height="300" alt="platform">

### Before running the pipeline:

Create a new YAML in `/Kubernetes-CI-CD/k8s` called `secret.yml` and fill in the secret variables.
> __Note: The variables have to be base64 encoded strings.__

        apiVersion: v1
        kind: Secret
        metadata:
          name: app-secrets
          labels:
            app: bootcampapp
        data:
          pghost: 
          pgusername: 
          pgpassword: 
          cookie_encrypt: 
          oktaclient: 
          oktasecret: 
          
Then run from the `k8s` directory:

        kubectl apply -f ./secret.yml


__Finally run the pipeline.__

