# 🚀 Terraform AWS Infrastructure as Code

Provision a complete AWS networking and compute environment using Terraform. This project deploys a **VPC with a public subnet, internet gateway, route table, security group, and an EC2 instance** — all defined as code for repeatable, version-controlled infrastructure.

---

## 📐 Architecture Diagram

```
┌──────────────────────────────────────────────────────┐
│                   AWS Cloud (us-east-1)               │
│                                                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │              VPC (10.0.0.0/16)                  │ │
│  │                                                 │ │
│  │  ┌──────────────────────────────────────────┐   │ │
│  │  │      Public Subnet (10.0.1.0/24)         │   │ │
│  │  │           AZ: us-east-1a                 │   │ │
│  │  │                                          │   │ │
│  │  │   ┌──────────────────────────────┐       │   │ │
│  │  │   │    EC2 Instance (t2.micro)   │       │   │ │
│  │  │   │    Name: Terraform-server    │       │   │ │
│  │  │   │    SG: web-sg               │       │   │ │
│  │  │   └──────────────────────────────┘       │   │ │
│  │  └──────────────────────────────────────────┘   │ │
│  │                    │                            │ │
│  │          ┌─────────┴─────────┐                  │ │
│  │          │   Route Table     │                  │ │
│  │          │   0.0.0.0/0 → IGW │                  │ │
│  │          └─────────┬─────────┘                  │ │
│  └────────────────────┼────────────────────────────┘ │
│                       │                              │
│              ┌────────┴────────┐                     │
│              │ Internet Gateway│                     │
│              └────────┬────────┘                     │
└───────────────────────┼──────────────────────────────┘
                        │
                   🌐 Internet
```

---

## 📁 Project Structure

| File               | Description                                               |
|--------------------|-----------------------------------------------------------|
| `provider.tf`      | AWS provider configuration and Terraform version constraints |
| `vpc.tf`           | VPC with CIDR block `10.0.0.0/16`                        |
| `pub-sub.tf`       | Public subnet (`10.0.1.0/24`) in `us-east-1a` with auto-assign public IP |
| `igw.tf`           | Internet Gateway attached to the VPC                      |
| `rt.tf`            | Route table with default route to IGW + subnet association |
| `sg.tf`            | Security group allowing SSH (22) and HTTP (80) inbound    |
| `ec2.tf`           | EC2 instance (`t2.micro`) launched in the public subnet   |
| `variables.tf`     | Input variable declarations                               |
| `terraform.tfvars` | Variable values (region, instance type, key name)         |
| `output.tf`        | Outputs: instance public IP and instance ID               |

---

## 🏗️ Resources Provisioned

| Resource                  | Name / Identifier    | Details                           |
|---------------------------|----------------------|-----------------------------------|
| **VPC**                   | `Terraform VPC`      | CIDR: `10.0.0.0/16`              |
| **Subnet**                | `Public-Subnet`      | CIDR: `10.0.1.0/24`, AZ: `us-east-1a`, Public IP: ✅ |
| **Internet Gateway**      | `InternetGateway`    | Attached to VPC                   |
| **Route Table**           | `PublicRouteTable`   | `0.0.0.0/0` → Internet Gateway   |
| **Security Group**        | `web-sg`             | Inbound: SSH (22), HTTP (80) · Outbound: All |
| **EC2 Instance**          | `Terraform-server`   | AMI: `ami-0b6d9d3d33ba97d99`, Type: `t2.micro` |

---

## ⚙️ Variables

| Variable        | Default          | Description                |
|-----------------|------------------|----------------------------|
| `region`        | `us-east-1`      | AWS region for deployment  |
| `instance_type` | `t2.micro`       | EC2 instance type          |
| `key_name`      | `terraform-key`  | Name of the SSH key pair   |

---

## 📤 Outputs

| Output               | Description                          |
|----------------------|--------------------------------------|
| `instance_public_ip` | Public IP address of the EC2 instance |
| `instance_id`        | Instance ID of the EC2 instance       |

---

## 🛠️ Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 0.15
- An AWS account with programmatic access configured
- AWS CLI configured (`aws configure`) or environment variables set:
  ```bash
  export AWS_ACCESS_KEY_ID="your-access-key"
  export AWS_SECRET_ACCESS_KEY="your-secret-key"
  ```
- An existing EC2 key pair named `terraform-key` (or update `terraform.tfvars`)

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/Akash-Raj-Official/terraform-iac-code.git
cd terraform-iac-code
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Preview the infrastructure changes
```bash
terraform plan
```

### 4. Deploy the infrastructure
```bash
terraform apply
```
Type `yes` when prompted to confirm.

### 5. Access your instance
```bash
ssh -i /path/to/terraform-key.pem ec2-user@<instance_public_ip>
```

### 6. Destroy the infrastructure (when done)
```bash
terraform destroy
```

---

## 🔒 Security Group Rules

| Direction | Protocol | Port | Source/Destination | Purpose |
|-----------|----------|------|--------------------|---------|
| Inbound   | TCP      | 22   | `0.0.0.0/0`       | SSH     |
| Inbound   | TCP      | 80   | `0.0.0.0/0`       | HTTP    |
| Outbound  | All      | All  | `0.0.0.0/0`       | All traffic |

> ⚠️ **Note:** The SSH and HTTP ports are open to all IPs (`0.0.0.0/0`). For production environments, restrict these to specific IP ranges.

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 🙋 Author

**Akash Raj** — [GitHub](https://github.com/Akash-Raj-Official)
