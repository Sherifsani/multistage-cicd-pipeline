# multistage-cicd-pipeline
a comprehensive multi stage CI/CD pipeline for a .NET application deployed azure

## steps
### 1. create the container registry
```bash
az acr create \
    --name cicdRegistry111 \
    --resource-group cicdgroup \
    --location germany-west-central \
    --sku Basic \

```

### 2. create the kubernetes service
```bash
az aks create \
    --resource-group cicdgroup \
    --name cicd-aks \
    --location 
```

