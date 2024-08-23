# Terraform Multi-Environment Infrastructure Setup

## Overview

This project sets up cloud infrastructure for both **development** and **production** environments using **Terraform** and **AWS**. The infrastructure includes VPC, EC2 instances, S3 buckets, and RDS instances. Terraform state management is handled using an **S3 backend** with **DynamoDB** for state locking.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Setting Up and Running Terraform](#setting-up-and-running-terraform)
  - [Development Environment](#development-environment)
  - [Production Environment](#production-environment)
  - [Destroying Infrastructure](#destroying-infrastructure)
- [Managing Terraform State](#managing-terraform-state)
  - [S3 Backend Configuration](#s3-backend-configuration)
  - [DynamoDB Locking](#dynamodb-locking)
  - [Working with the State](#working-with-the-state)
- [Extending or Modifying the Infrastructure](#extending-or-modifying-the-infrastructure)
  - [Example of Adding a New Module](#example-of-adding-a-new-module)

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Valid AWS credentials configured locally using `aws configure`.

Ensure your AWS CLI is authenticated and configured with the proper access rights to provision resources (e.g., VPC, EC2, S3, RDS) on AWS.

### Backend Setup: S3 Bucket and DynamoDB Table

Before running Terraform, you must manually create the S3 bucket and DynamoDB table that will be used for state management and locking.

#### Steps to Create the S3 Bucket

1. Open the [AWS Management Console](https://aws.amazon.com/console/).
2. Navigate to **S3**.
3. Create a new S3 bucket with a globally unique name (e.g., `my-terraform-state-bucket`).
4. Enable versioning on the bucket to track changes to the state files.

#### Steps to Create the DynamoDB Table

1. Open the [AWS Management Console](https://aws.amazon.com/console/).
2. Navigate to **DynamoDB**.
3. Create a new DynamoDB table with the following specifications:
   - **Table name**: `terraform-locks`
   - **Partition key**: `LockID` (type `String`)
4. Set the billing mode to **Pay-per-request**.

These resources will be used by Terraform for managing remote state and preventing concurrent operations through state locking.

## Project Structure

```bash
terraform/
├── development/
│   ├── .terraform/
│   ├── main.tf
│   ├── output.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── variables.tf
├── production/
│   ├── .terraform/
│   ├── main.tf
│   ├── output.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── variables.tf
├── modules/
│   ├── ec2/
│   ├── rds/
│   ├── s3/
│   └── vpc/
└── .github/
    └── workflows/
        └── terraform-ci.yml

```

## Setting Up and Running Terraform

### Step 1: Clone the Repository

```bash
git clone https://github.com/your-repo-name.git
cd terraform
```

### Step 2: Initialize Terraform

To initialize Terraform in a specific environment (e.g., development), run:

```bash
cd development
terraform init

```

This will initialize the Terraform backend (S3) and download required provider plugins.

### Step 3: Plan and Apply Infrastructure

```bash
cd development
terraform plan
terraform apply -auto-approve

```

### Step 4: Destroying Infrastructure

```bash
terraform destroy
```

## Working with the State

- Automatic State Management: Terraform automatically handles the state files, storing them in the S3 bucket. No manual intervention is required.
- Migrate State: If there are changes to the backend, you can migrate the state using the terraform init -migrate-state command.

## Extending or Modifying the Infrastructure

The infrastructure is modular and can be easily extended or modified. Here’s how:

- **Adding New Resources**: Add new resources to the relevant module (e.g., EC2 instances to the ec2 module, or new S3 buckets to the s3 module).
- **Modifying Existing Resources**: To change the configuration of existing resources (e.g., instance type, VPC CIDR block), update the relevant variables.tf file or modify the appropriate resource block in the module.
- **Creating New Modules**: If new types of infrastructure are needed (e.g., Load Balancers, Lambda functions), create a new module in the modules/ directory and invoke it in both the development and production main.tf files.
- **Scaling**: You can scale the infrastructure (e.g., adding more EC2 instances or modifying RDS configurations) by updating the variables and re-running terraform apply.
