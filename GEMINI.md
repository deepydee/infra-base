# Project Context: Infrastructure Base (Modernized)

## Overview
This project provides a comprehensive **Infrastructure as Code (IaC)** solution using **Ansible** to provision and manage a **Docker Swarm** based development server (Debian 13). It is designed to be secure, modular, and easy to deploy.

## Key Technologies
*   **Ansible**: Configuration management and automation.
*   **Docker Swarm**: Container orchestration.
*   **Traefik**: Reverse proxy and load balancer with automatic Let's Encrypt SSL.
*   **GitLab CE**: Self-hosted DevOps platform (Source Code, CI/CD, Container Registry).
*   **Prometheus & Grafana**: Monitoring and visualization stack.
*   **Portainer**: Web UI for container management.
*   **Fail2Ban & UFW**: Security hardening.

## Architecture & Roles

The project is structured using Ansible roles:

*   **`common`**: System updates, essential utilities (curl, git, htop), and swap configuration.
*   **`security`**:
    *   Creates a `deploy` user with sudo privileges.
    *   Hardens SSH: Changes port to **15022**, disables root login, enforces key-based authentication.
    *   Configures UFW firewall (allows ports 80, 443, 2222, 15022).
    *   Sets up Fail2Ban.
*   **`docker`**: Installs Docker CE (from official repos), initializes Docker Swarm, and creates the `traefik-public` overlay network.
*   **`stacks`**: Deploys application stacks via `docker stack deploy`:
    *   **Traefik**: Entrypoint for HTTP/HTTPS.
    *   **GitLab**: Integrated CI/CD platform with Registry.
    *   **Portainer**: Docker management UI.
    *   **Monitoring**: Prometheus (metrics), Node Exporter (host metrics), cAdvisor (container metrics), Grafana (dashboards).

## Setup & Usage

### 1. Prerequisites
*   A fresh Debian 13 (or 12) VPS.
*   A domain name with `*.domain.com` pointing to the VPS IP.
*   Ansible installed locally.

### 2. Configuration
Edit `provisioning/inventory/hosts.yml` (create it if missing, using the example structure) and `provisioning/inventory/group_vars/all.yml` to set:
*   `hostname`
*   `domain_root`
*   `ssh_port` (default: 15022)
*   `gitlab_root_password`
*   `grafana_admin_password`
*   `traefik_basic_auth`
*   `email_admin` (for SSL)

### 3. Deployment Commands (via Makefile)

| Command | Description |
| :--- | :--- |
| `make bootstrap` | **Initial Setup**: Runs on a fresh server (port 22). Updates system, secures SSH (moves to 15022), and creates the `deploy` user. |
| `make deploy` | **Main Deploy**: connects via port 15022. Installs Docker, Swarm, and deploys all stacks (Traefik, GitLab, Monitoring, etc.). |
| `make deploy-stacks` | **Fast Update**: Re-runs only the stack deployment tasks (useful for config changes). |
| `make ping` | Checks connectivity to the server. |

## Infrastructure Services
Once deployed, services are available at:

*   **Traefik Dashboard**: `https://traefik.yourdomain.com`
*   **GitLab**: `https://git.yourdomain.com`
*   **GitLab Registry**: `https://registry.yourdomain.com`
*   **Grafana**: `https://grafana.yourdomain.com`
*   **Portainer**: `https://portainer.yourdomain.com`

## Development Conventions
*   **Idempotency**: All playbooks are safe to re-run.
*   **Security First**: SSH runs on a non-standard port (15022). Root login is disabled.
*   **Stack-Based Deployment**: Applications are defined as Docker Stacks (`/opt/stacks/`) and templated via Ansible.
*   **Persistent Data**: All critical data (GitLab, Prometheus, Grafana) is stored in persistent volumes or host directories.
