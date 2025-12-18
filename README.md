# multistage-cicd-pipeline

A **multi-stage CI/CD pipeline** for an **ASP.NET Core (.NET) application** deployed to **Azure Kubernetes Service (AKS)** using **Azure DevOps** and **Azure Container Registry (ACR)**.

This project demonstrates a complete DevOps workflow:
**Code → Build → Containerize → Push → Deploy to Kubernetes**.

---

## 🏗️ Architecture Overview

* **Application**: ASP.NET Core (.NET)
* **CI/CD**: Azure DevOps Pipelines
* **Container Registry**: Azure Container Registry (ACR)
* **Orchestration**: Azure Kubernetes Service (AKS)
* **Containerization**: Docker (multi-stage build)

**Pipeline Flow:**

```
Git Push → Azure DevOps Pipeline → ACR → AKS
```

---

## 📁 Project Structure

```
.
├── src/
│   └── WebApp/
│       ├── WebApp.csproj
│       └── Program.cs
├── docker/
│   └── Dockerfile
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── azure-pipelines.yml
└── README.md
```

---

## 🚀 Setup Steps

### 1️⃣ Create Azure Container Registry (ACR)

```bash
az acr create \
    --name cicdimagerepo \
    --resource-group cicdgroup \
    --location germanywestcentral \
    --sku Basic
```

This registry stores Docker images built by the CI/CD pipeline.

---

### 2️⃣ Create Azure Kubernetes Service (AKS)

```bash
az aks create \
    --resource-group cicdgroup \
    --name cicd-aks \
    --location germanywestcentral \
    --node-count 2 \
    --node-vm-size Standard_B2ps_v2 \
    --enable-managed-identity \
    --generate-ssh-keys
```

This creates a managed Kubernetes cluster with two worker nodes.

---

### 3️⃣ Get AKS Credentials

This allows `kubectl` to communicate with the cluster.

```bash
az aks get-credentials \
    --resource-group cicdgroup \
    --name cicd-aks
```

Verify access:

```bash
kubectl get nodes
```

Expected output (example):

```bash
NAME                                STATUS   ROLES    AGE     VERSION
aks-nodepool1-xxxxxx-vmss000000     Ready    <none>   5m      v1.33.5
aks-nodepool1-xxxxxx-vmss000001     Ready    <none>   5m      v1.33.5
```

---

### 4️⃣ Create Kubernetes Namespaces

Separate namespaces are created for environment isolation.

```bash
kubectl create namespace dev
kubectl create namespace test
kubectl create namespace prod
```

Verify:

```bash
kubectl get namespaces
```

---

### 5️⃣ Attach ACR to AKS

This allows AKS to pull images from ACR **without Docker secrets**.

```bash
az aks update \
  --resource-group cicdgroup \
  --name cicd-aks \
  --attach-acr cicdimagerepo
```

---

### 6️⃣ Create Azure DevOps Service Connections

Two service connections are required in Azure DevOps:

#### 🔹 Azure Resource Manager

* Used to authenticate to Azure and interact with AKS
* Scope: Subscription

#### 🔹 Docker Registry (ACR)

* Used to build and push Docker images
* Connected to `cicdimagerepo`

These service connections are referenced in `azure-pipelines.yml`.

---

## ⚙️ CI/CD Pipeline Overview

The Azure DevOps pipeline performs the following:

### Build Stage

* Builds the Docker image using a **multi-stage Dockerfile**
* Pushes the image to **Azure Container Registry**

### Deploy Stage

* Connects to AKS
* Deploys the application using Kubernetes manifests

Pipeline file:

```
azure-pipelines.yml
```

---

## 🌐 Application Deployment

Kubernetes manifests are located in the `k8s/` directory:

* `deployment.yaml` → Defines pods and replicas
* `service.yaml` → Exposes the app using a LoadBalancer

After deployment:

```bash
kubectl get svc
```

Access the application via the assigned **EXTERNAL-IP**.

---

## ✅ Outcome

* Fully automated CI/CD pipeline
* Dockerized .NET application
* Secure image pull from ACR
* Deployed and running on AKS
* Ready for production-style workflows

---

## 📌 Notes

* Region used: `germanywestcentral` (policy-compliant for the subscription)
* Managed identity is used for secure Azure access
* Pipeline triggers automatically on pushes to the `main` branch

---

## 🧠 What This Demonstrates

* Real-world CI/CD practices
* Azure DevOps pipelines
* Docker multi-stage builds
* Kubernetes deployment on AKS
* Clean separation of concerns


