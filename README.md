# multistage-cicd-pipeline
a comprehensive multi stage CI/CD pipeline for a .NET application deployed azure

## steps
### 1. create the container registry
```bash
az acr create \
    --name cicdimagerepo \
    --resource-group cicdgroup \
    --location germanywestcentral \
    --sku Basic \

```

### 2. create the kubernetes service
```bash
az aks create \
    --resource-group cicdgroup \
    --name cicd-aks \
    --location germanywestcentral \
    --node-count 2 \
    --node-vm-size Standard_B2ps_v2
    --enable-managed-identity \
    --generate-ssh-keys
```

### 3. get AKS credentials (so Kubectl can talk to it)
Once AKS is created, run the following:

```bash
az aks get-credentials \
    --resource-group cicdgroup \
    --name cicd-aks
```
to test
```bash
kubectl get nodes
```

you should see something like this
```bash
NAME                                STATUS   ROLES    AGE     VERSION
aks-nodepool1-38926676-vmss000000   Ready    <none>   4m9s    v1.33.5
aks-nodepool1-38926676-vmss000001   Ready    <none>   4m10s   v1.33.5
```

### 4. create namespaces for dev, test and prod

```bash
kubectl create namespace dev
kubectl create namespace test
kubectl create namespace prod
```

verify with:
```bash
kubectl get namespaces
```


### 5. attach ACR to AKS

This ensures that AKS can pull docker images from ACR without secrets

```bash
az aks update \
  --resource-group cicdgroup \
  --name cicd-aks \
  --attach-acr cicdimagerepo

```

### 6. Create the service connections in Azure Devops
