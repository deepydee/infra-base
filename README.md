# Infrastructure Base (Modernized)

A production-ready **Infrastructure as Code (IaC)** solution for deploying a self-hosted development environment. It automates the provisioning of a **Debian 13** VPS into a secure **Docker Swarm** cluster with a full CI/CD and monitoring stack.

## 🚀 Key Features

*   **Security Hardening**: Custom SSH port (15022), Root login disabled, Key-based authentication, UFW Firewall, and Fail2Ban.
*   **Edge Routing**: **Traefik v2** with automatic **Let's Encrypt** SSL/TLS certificates.
*   **DevOps Suite**:
    *   **GitLab CE**: Source control, CI/CD pipelines, and built-in Container Registry.
    *   **Portainer**: Web-based management for Docker Swarm stacks and containers.
*   **Full Observability**:
    *   **Prometheus**: Metrics collection.
    *   **Grafana**: Beautiful dashboards for host and container monitoring.
    *   **cAdvisor & Node Exporter**: Detailed metrics for containers and system hardware.
*   **Optimized Performance**: Automated 4GB Swap configuration for smooth operation of heavy services like GitLab.

## 🛠 Tech Stack

*   **Ansible**: Configuration management.
*   **Docker Swarm**: Orchestration.
*   **Traefik**: Reverse Proxy / Load Balancer.
*   **Debian 13 (Trixie)**: Base Operating System.

## 📁 Project Structure

```text
.
├── Makefile                # Management aliases
├── ansible.cfg             # Ansible configuration
├── provisioning/
│   ├── inventory/          # Hosts and group variables
│   ├── roles/              # Modular Ansible roles (common, security, docker, stacks)
│   ├── bootstrap.yml       # Initial server setup (Run once)
│   └── site.yml            # Main infrastructure deployment
└── GEMINI.md               # Detailed project context for AI agents
```

## 🚦 Quick Start

### 1. Prerequisites
*   A fresh VPS with Debian 13 (Debian 12 also supported).
*   A domain (e.g., `example.com`) with DNS records:
    *   `A` record `@` pointing to VPS IP.
    *   `A` record `git`, `registry`, `traefik`, `portainer`, `grafana` pointing to VPS IP (or a Wildcard `*`).
*   Ansible installed on your local machine.

### 2. Configuration
Create your inventory file:
```bash
cp provisioning/inventory/hosts.yml.dist provisioning/inventory/hosts.yml # If template exists, otherwise create it
```

Edit `provisioning/inventory/hosts.yml` and `provisioning/inventory/group_vars/all.yml` with your specific details (domain, emails, passwords).

### 3. Deployment

**Step 1: Bootstrap (Initial Setup)**
Connects via port 22 as root to secure the server and create the `deploy` user.
```bash
make bootstrap
```

**Step 2: Main Deployment**
Connects via the new secure port 15022 to install Docker and deploy all services.
```bash
make deploy
```

## 🌐 Available Services

| Service | URL |
| :--- | :--- |
| **GitLab** | `https://git.yourdomain.com` |
| **Registry** | `https://registry.yourdomain.com` |
| **Grafana** | `https://grafana.yourdomain.com` |
| **Portainer** | `https://portainer.yourdomain.com` |
| **Traefik** | `https://traefik.yourdomain.com` |

## 🛡 Security Notes
*   **SSH**: Now listens on port **15022**. Root password login is disabled.
*   **GitLab SSH**: Use port **2222** for git operations (e.g., `git clone ssh://git@git.yourdomain.com:2222/...`).
*   **Secrets**: Ensure you update default passwords in `group_vars/all.yml` immediately after deployment.

## 📄 License
MIT
