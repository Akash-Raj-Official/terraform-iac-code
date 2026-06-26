# 🚀 Terraform AWS Infrastructure as Code

Provision a complete AWS networking and compute environment using Terraform. This project deploys a **VPC with public & private subnets, internet gateway, NAT gateway, route tables, security group, and an EC2 instance** — all defined as code for repeatable, version-controlled infrastructure.

---

## 📐 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                      AWS Cloud (us-east-1)                      │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                   VPC (10.0.0.0/16)                      │   │
│  │                                                          │   │
│  │  ┌───────────────────────────────────────────────────┐   │   │
│  │  │          Public Subnet (10.0.1.0/24)              │   │   │
│  │  │                AZ: us-east-1a                     │   │   │
│  │  │                                                   │   │   │
│  │  │   ┌─────────────────────────┐  ┌───────────────┐ │   │   │
│  │  │   │  EC2 Instance (t2.micro)│  │  NAT Gateway  │ │   │   │
│  │  │   │  Name: Terraform-server │  │  + Elastic IP │ │   │   │
│  │  │   │  SG: web-sg             │  └───────┬───────┘ │   │   │
│  │  │   └─────────────────────────┘          │         │   │   │
│  │  └──────────────────────────────────────── ┼ ───────┘   │   │
│  │               │  Public RT                 │            │   │
│  │               │  0.0.0.0/0 → IGW           │            │   │
│  │  ┌──────────────────────────────────────── ┼ ───────┐   │   │
│  │  │          Private Subnet (10.0.2.0/24)   │        │   │   │
│  │  │                AZ: us-east-1a           │        │   │   │
│  │  │                                         │        │   │   │
│  │  │   ┌─────────────────────────┐           │        │   │   │
│  │  │   │  Private EC2 / Resource │──────────►│        │   │   │
│  │  │   │  No Public IP ❌        │  Private RT│        │   │   │
│  │  │   └─────────────────────────┘  0.0.0.0/0→NAT     │   │   │
│  │  └───────────────────────────────────────────────────┘   │   │
│  │                        │                                 │   │
│  │              ┌──────────┴──────────┐                     │   │
│  │              │  Internet Gateway   │                     │   │
│  │              └──────────┬──────────┘                     │   │
│  └─────────────────────────┼──────────────────────────────┘    │
└────────────────────────────┼────────────────────────────────────┘
                             │
                        🌐 Internet
```

**Traffic Flow:**
- 🟢 **Public Subnet** → Internet Gateway → Internet (bidirectional)
- 🔒 **Private Subnet** → NAT Gateway → Internet Gateway → Internet (outbound only — no inbound from internet)

---

## 📁 Project Structure

| File               | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| `provider.tf`      | AWS provider configuration and Terraform version constraints                |
| `vpc.tf`           | VPC with CIDR block `10.0.0.0/16`                                           |
| `pub-sub.tf`       | Public subnet (`10.0.1.0/24`) in `us-east-1a` with auto-assign public IP   |
| `private-sub.tf`   | Private subnet (`10.0.2.0/24`) in `us-east-1a` — no public IP              |
| `igw.tf`           | Internet Gateway attached to the VPC                                        |
| `nat.tf`           | Elastic IP + NAT Gateway (in public subnet) for private subnet outbound     |
| `rt.tf`            | Public route table (→ IGW) + Private route table (→ NAT) + associations    |
| `sg.tf`            | Security group allowing SSH (22) and HTTP (80) inbound                      |
| `ec2.tf`           | EC2 instance (`t2.micro`) launched in the public subnet                     |
| `variables.tf`     | Input variable declarations                                                 |
| `terraform.tfvars` | Variable values (region, instance type, key name)                           |
| `output.tf`        | Outputs: instance public IP and instance ID                                 |

---

## 🏗️ Resources Provisioned

| Resource                  | Name / Identifier      | Details                                                   |
|---------------------------|------------------------|-----------------------------------------------------------|
| **VPC**                   | `Terraform VPC`        | CIDR: `10.0.0.0/16`                                       |
| **Public Subnet**         | `Public-Subnet`        | CIDR: `10.0.1.0/24`, AZ: `us-east-1a`, Public IP: ✅     |
| **Private Subnet**        | `Private-Subnet`       | CIDR: `10.0.2.0/24`, AZ: `us-east-1a`, Public IP: ❌     |
| **Internet Gateway**      | `InternetGateway`      | Attached to VPC for public subnet access                  |
| **Elastic IP**            | `NAT-EIP`              | Static public IP assigned to NAT Gateway                  |
| **NAT Gateway**           | `NAT-Gateway`          | Lives in public subnet; gives private subnet outbound access |
| **Public Route Table**    | `PublicRouteTable`     | `0.0.0.0/0` → Internet Gateway                            |
| **Private Route Table**   | `PrivateRouteTable`    | `0.0.0.0/0` → NAT Gateway (no direct internet access)     |
| **Security Group**        | `web-sg`               | Inbound: SSH (22), HTTP (80) · Outbound: All              |
| **EC2 Instance**          | `Terraform-server`     | AMI: `ami-0b6d9d3d33ba97d99`, Type: `t2.micro`            |

---

## ⚙️ Variables

| Variable        | Default          | Description                |
|-----------------|------------------|----------------------------|
| `region`        | `us-east-1`      | AWS region for deployment  |
| `instance_type` | `t2.micro`       | EC2 instance type          |
| `key_name`      | `terraform-key`  | Name of the SSH key pair   |

---

## 📤 Outputs

| Output               | Description                           |
|----------------------|---------------------------------------|
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

### 5. Access your EC2 instance (public subnet)
```bash
ssh -i /path/to/terraform-key.pem ec2-user@<instance_public_ip>
```

### 6. Destroy the infrastructure (when done)
```bash
terraform destroy
```

> ⚠️ **Cost Warning:** The NAT Gateway costs ~$0.045/hr + data transfer charges on AWS. Always run `terraform destroy` when the environment is no longer needed.

---

## 🔒 Security Group Rules

| Direction | Protocol | Port | Source/Destination | Purpose |
|-----------|----------|------|--------------------|---------| 
| Inbound   | TCP      | 22   | `0.0.0.0/0`       | SSH     |
| Inbound   | TCP      | 80   | `0.0.0.0/0`       | HTTP    |
| Outbound  | All      | All  | `0.0.0.0/0`       | All traffic |

> ⚠️ **Note:** The SSH and HTTP ports are open to all IPs (`0.0.0.0/0`). For production environments, restrict these to specific IP ranges.

---

## 🔐 Private Subnet — Key Points

- Resources in the **private subnet have no public IP** and are **not directly reachable from the internet**
- They can still make **outbound requests** (e.g., `yum update`, `apt install`, API calls) via the **NAT Gateway**
- To access private resources, use a **Bastion Host** in the public subnet or **AWS Systems Manager Session Manager**
- Private subnet uses a **separate route table** that points `0.0.0.0/0` → NAT Gateway (not IGW)

---

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).

---

## 🙋 Author

**Akash Raj** — [GitHub](https://github.com/Akash-Raj-Official)
