TERRAFORM := $(shell which terraform 2>/dev/null)

.PHONY: check-terraform check-vars init plan show apply clean new_repo

check-terraform:
ifndef TERRAFORM
	@echo "Terraform not installed..."
	@exit 1
else
	@terraform version
endif

check-vars:
ifndef TF_VAR_repo_name
	@echo "Error: TF_VAR_repo_name is not set. Run: export TF_VAR_repo_name=your-repo-name"
	@exit 1
endif
ifndef TF_VAR_repo_token
	@echo "Error: TF_VAR_repo_token is not set. Run: export TF_VAR_repo_token=your-token"
	@exit 1
endif
	@echo "All required variables are set."

init:
	@echo "Initialising Terraform..."
	@terraform init

plan: 
	@echo "Running terraform plan..."
	@terraform plan -out=tfplan

show: 
	@echo "Running terraform show..."
	@terraform show tfplan

apply: 
	@echo "Running terraform apply..."
	@terraform apply -auto-approve

clean:
	@echo "Cleaning up Terraform files..."
	rm -rf .terraform .terraform.lock.hcl terraform.tfstate terraform.tfstate.backup tfplan

### Group workflow local testing###	
new_repo: clean check-terraform check-vars init plan show apply
