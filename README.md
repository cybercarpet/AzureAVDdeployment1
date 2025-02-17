Azure Virtual Desktop (AVD) Deployment with Terraform & Azure DevOps

Overview

This project provides a fully automated deployment of Azure Virtual Desktop (AVD) using Terraform and an Azure DevOps CI/CD pipeline. The deployment includes auto-scaling session hosts, monitoring alerts, and cost-saving auto-shutdown policies.

Features

✅ Infrastructure as Code (IaC) with Terraform✅ CI/CD Pipeline for automated deployment via Azure DevOps✅ Auto-Scaling based on session usage✅ Monitoring Alerts for CPU & Memory thresholds✅ Auto-Shutdown to reduce costs

Prerequisites

Before deploying this project, ensure you have the following:

Azure Subscription (Pay-As-You-Go or Free Trial)

Azure Service Connection configured in Azure DevOps

Terraform CLI installed (if running locally)

Azure CLI installed

GitHub Repository (for version control)

Deployment Steps

1️⃣ Clone the Repository

git clone https://github.com/your-repo/Azure-AVD-Terraform.git
cd Azure-AVD-Terraform

2️⃣ Configure Terraform Backend (If Using Remote State)

Modify backend.tf to use Azure Storage for remote state management:

terraform {
  backend "azurerm" {
    resource_group_name  = "your-backend-rg"
    storage_account_name = "yourstorageaccount"
    container_name       = "terraform-state"
    key                  = "avd.tfstate"
  }
}

3️⃣ Initialize Terraform

terraform init

4️⃣ Plan Deployment

terraform plan -out=tfplan

5️⃣ Apply Deployment

terraform apply -auto-approve tfplan

6️⃣ Verify AVD Deployment

Go to Azure Portal → Azure Virtual Desktop → Check for Host Pool

Ensure Session Host VMs are created

Test Login to AVD using Remote Desktop

Azure DevOps CI/CD Pipeline Setup

1️⃣ Create an Azure DevOps Service Connection

Navigate to Azure DevOps → Project Settings → Service Connections

Create a new Azure Resource Manager service connection

Name it Your-Azure-Service-Connection

2️⃣ Add the Pipeline to Azure DevOps

Navigate to Azure DevOps → Pipelines → New Pipeline

Select GitHub and choose your repository

Use the provided azure_devops_pipeline.yaml file

3️⃣ Run the Pipeline

Click Run Pipeline to start the deployment

Monitoring & Alerts

Auto-Scaling Policy

Scales up if session host usage exceeds 90%

Scales down if session host usage drops below 50%

Alerts Configured

CPU Usage > 80% → Triggers an alert

Memory Usage < 25% → Triggers an alert

Notifications sent to: admin@mockemail.com

Cost Optimization

Auto-Shutdown Configuration

Enabled via Azure Automation Account

VMs shutdown daily at 8 PM CET to reduce costs

Cleanup (Optional)

To remove all deployed resources, run:

terraform destroy -auto-approve

Screenshots (For Showcase)

🔹 [Include screenshots of AVD Host Pool, VMs, and Azure DevOps Pipeline]

Future Improvements

🔹 Add Azure Sentinel integration for security logging🔹 Implement Bicep as an alternative to Terraform

License

MIT License. Free to use and modify.
