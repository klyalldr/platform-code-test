PATH:= $(PATH):$(GOBIN)
export PATH
SHELL:= env PATH=$(PATH) /bin/bash

ENV?=production


tf-apply: tf-init
	cd terraform/environments/$(ENV) && terraform apply -auto-approve

tf-destroy:
	cd terraform/environments/$(ENV) && terraform destroy

tf-fmt:
	cd terraform/environments/$(ENV) && terraform fmt -recursive

tf-init:
	cd terraform/environments/$(ENV) && terraform init

tf-plan: tf-init
	cd terraform/environments/$(ENV) && terraform plan
