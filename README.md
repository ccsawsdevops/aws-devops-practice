# AWS DevOps CI/CD Pipeline

A complete CI/CD pipeline built on AWS using CodePipeline, CodeBuild, and CodeDeploy, with integrated security scanning.

## Architecture
## Services Used

| Service | Purpose |
|---------|---------|
| AWS CodePipeline | Orchestrates the full CI/CD pipeline |
| AWS CodeBuild | Builds app and runs security scans |
| AWS CodeDeploy | Deploys application to EC2 |
| Amazon EC2 | Hosts the web application |
| Amazon S3 | Stores pipeline artifacts |
| Amazon SNS | Sends pipeline notifications |
| Amazon CloudWatch | Monitors CPU and triggers alerts |

## Security Scanning

- **Gitleaks** — detects hardcoded secrets and credentials before they reach production
- **Checkov** — scans Infrastructure as Code for security misconfigurations

## Pipeline Stages

### 1. Source
- Triggered automatically on every push to `main` branch
- Source code pulled from GitHub via OAuth

### 2. Build (CodeBuild)
- Installs security scanning tools
- Runs Gitleaks secrets detection
- Runs Checkov IaC scanning
- Builds the application
- Packages artifacts to S3

### 3. Deploy (CodeDeploy)
- Downloads artifacts from S3
- Runs `before_install.sh` — installs Apache
- Copies files to `/var/www/html`
- Runs `after_install.sh` — sets permissions
- Runs `start_server.sh` — starts Apache

## Monitoring

- CloudWatch alarm on CPU utilization (threshold: 80%)
- SNS email notifications when alarm triggers
- Tested with CPU stress tool — alarm triggered and email received within 2 minutes

## Repository Structure
GitHub Push
↓
CodePipeline (automatic trigger)
↓
CodeBuild
├── Gitleaks  (secrets detection)
├── Checkov   (IaC security scanning)
└── Build app
↓
CodeDeploy → EC2 (Apache web server)

├── appspec.yml          # CodeDeploy deployment manifest
├── buildspec.yml        # CodeBuild build + security scan spec
├── index.html           # Web application
└── scripts/
├── before_install.sh  # Pre-deployment script
├── after_install.sh   # Post-deployment script
└── start_server.sh    # Application start script
## Key Learnings

- Configured IAM roles with least privilege for CodePipeline, CodeBuild, and CodeDeploy
- Integrated security scanning as a mandatory pipeline gate
- Set up CloudWatch monitoring with SNS alerts
- Debugged real pipeline failures (artifact naming, IAM permissions, service connections)
