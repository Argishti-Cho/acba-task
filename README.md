## Task 1: Provisioning Kubernetes and the ELK Stack with Log Shipping Automation

### Prerequisites

Ensure you have the following tools installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Helm](https://helm.sh/docs/intro/install/)

### Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/your-repo.git
   cd your-repo

2. **Initialize and Apply Terraform**
    ```bash
    terraform init
    terraform apply

Note: The process may take approximately 7–10 minutes. If it takes significantly longer, review the output for potential issues.

3. Access Kibana dashboard
    Once the deployment is complete, access Kibana in your browser at: [link]kubernetes.kibana.internal