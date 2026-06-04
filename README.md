# Terraform Repo Automation

Automates creating a GitHub repository using Terraform, driven by a `Makefile`.

---

## Prerequisites

### 1. WSL (Windows Subsystem for Linux)
This project runs on **WSL Ubuntu**. Ensure WSL is installed and you are running commands from a WSL terminal.

- [Install WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

### 2. Make
Required to run the Makefile targets.

```bash
sudo apt update && sudo apt install make
```

### 3. Terraform
Install Terraform on WSL Ubuntu:

```bash
sudo apt update && sudo apt install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | \
  sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
  https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
  sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform
```

Verify installation:
```bash
terraform -version
```

---

## Environment Variables

The following environment variables must be set in your local shell before running any `make` commands. Terraform picks these up automatically via the `TF_VAR_*` prefix.

| Variable | Required | Description |
|---|---|---|
| `TF_VAR_repo_name` | **Required** | Name of the GitHub repository to create |
| `TF_VAR_repo_token` | **Required** | GitHub personal access token with repo permissions |

Set them in your shell:
```bash
export TF_VAR_repo_name="your-repo-name"
export TF_VAR_repo_token="your-github-token"
```

To persist them across sessions, add the exports to your `~/.bashrc` or `~/.zshrc`.

---

## Usage

### Create a new repo
The main command. Runs the full workflow in one shot:

```bash
make new_repo
```

This runs the following steps in order:

| Step | Command | Description |
|---|---|---|
| 1 | `clean` | Removes any existing Terraform files before starting fresh |
| 2 | `check-terraform` | Verifies Terraform is installed and prints the version |
| 3 | `check-vars` | Validates `TF_VAR_repo_name` and `TF_VAR_repo_token` are set |
| 4 | `init` | Initialises Terraform and downloads required providers |
| 5 | `plan` | Generates an execution plan and saves it to `tfplan` |
| 6 | `show` | Displays the saved `tfplan` for review |
| 7 | `apply` | Applies the plan automatically (`-auto-approve`) |

### Clean up Terraform files
Removes local Terraform state, cache, and plan files:
```bash
make clean
```

Removes the following:
- `.terraform/`
- `.terraform.lock.hcl`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- `tfplan`

---

## Debug Targets
Run individual Terraform steps for troubleshooting:

```bash
make init    # Initialise Terraform
make plan    # Generate and save plan to tfplan
make show    # Display the saved tfplan
make apply   # Apply the plan with auto-approve
```

---

## Makefile Checks

Before running any Terraform commands, the Makefile will automatically verify:

- ✅ Terraform is installed on the system
- ✅ `TF_VAR_repo_name` is set
- ✅ `TF_VAR_repo_token` is set

If any check fails, the process stops with a clear error message.
