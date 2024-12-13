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
   git clone https://github.com/Argishti-Cho/acba-task.git
   cd terraform

2. **Initialize and Apply Terraform**
    ```bash
    terraform init
    terraform apply

Note: The process may take approximately 7–10 minutes. If it takes significantly longer, review the output for potential issues.

3. Access Kibana dashboard
    Once the deployment is complete, access Kibana in your browser, simply click the following link: [kibana](http://kubernetes.kibana.internal)


## Task 2: System Resource Monitoring and Notification Script

### Prerequisites

1. Install Python
Ensure Python is installed on your system. Follow the [official Python installation guide](https://www.python.org/downloads/) for detailed instructions.

2. Install Python Modules

Upgrade **pip** and install the required Python modules by running the following commands:

```bash
sudo apt install python3-pip -y
pip install --upgrade pip
pip install psutil requests logging
```

3. Go to monitoring directory and run the following commands
```bash
chmod +x create-service.sh
sudo ./create-service.sh
```
For uninstalling simply run: `chmod uninstall.sh` and `sudo ./uninstall.sh`.

Note: The slack account which receives the warning message belongs to the Repository owner, to be added in the slack channel please contact to the repository owner.