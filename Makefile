CLUSTER_NAME ?= dscott-test
LOCATION ?= East US
RESOURCE_GROUP_VNET ?= $(CLUSTER_NAME)-vnet-rg
RESOURCE_GROUP_ARO ?= $(CLUSTER_NAME)-rg
RESOURCE_GROUP_CLUSTER ?= $(CLUSTER_NAME)-cluster-rg
VNET ?= $(CLUSTER_NAME)-vnet
SUBNET_CONTROL_PLANE ?= $(CLUSTER_NAME)-control-plane
SUBNET_WORKER ?= $(CLUSTER_NAME)-worker

#
# network:
#   simulates the network-administrator persona to create the network architecture for ARO
#
network:
	@cd network-administrator/test && \
		terraform init && \
		terraform apply \
			-var="location=$(LOCATION)" \
			-var="resource_group_vnet=$(RESOURCE_GROUP_VNET)" \
			-var="vnet=$(VNET)"


network-destroy:
	@cd network-administrator/test && \
		terraform init && \
		terraform apply -destroy \
			-var="location=$(LOCATION)" \
			-var="resource_group_vnet=$(RESOURCE_GROUP_VNET)" \
			-var="vnet=$(VNET)"

#
# permissions:
#   simulates the azure-ad-administrator persona to create the appropriate service
#   principals, resource groups, and assign minimimal permissions to the appropriate 
#   objects.
#
# NOTE: requires 'network' first.  outputs from 'network' will be used as inputs to this
#
permissions:
	@cd azure-ad-administrator/test && \
		terraform init && \
		terraform apply \
			-var="location=$(LOCATION)" \
			-var="cluster_name=$(CLUSTER_NAME)" \
			-var="resource_group_vnet=$(RESOURCE_GROUP_VNET)" \
			-var="resource_group_aro=$(RESOURCE_GROUP_ARO)" \
			-var="vnet=$(VNET)"

permissions-destroy:
	@cd azure-ad-administrator/test && \
		terraform init && \
		terraform apply -destroy \
			-var="location=$(LOCATION)" \
			-var="cluster_name=$(CLUSTER_NAME)" \
			-var="resource_group_vnet=$(RESOURCE_GROUP_VNET)" \
			-var="resource_group_aro=$(RESOURCE_GROUP_ARO)" \
			-var="vnet=$(VNET)"

#
# cluster:
#   simulates the cluster-creator persona, using a service principal, to create a cluster
#   with minimal permissions assigned.
#
# NOTE: requires 'network' first.  outputs from 'network' will be used as inputs to this
# NOTE: reuquires 'permissions' next.  outputs from 'permissions' will be used as inputs to this
cluster:
	@export CLUSTER_CLIENT_ID=`cat azure-ad-administrator/test/terraform.tfstate | jq -r '.outputs.test.value.service_principal_cluster_client_id'` && \
		export CLUSTER_CLIENT_SECRET=`cat azure-ad-administrator/test/terraform.tfstate | jq -r '.outputs.test.value.service_principal_cluster_client_secret'` && \
		export CLUSTER_CREATOR_CLIENT_ID=`cat azure-ad-administrator/test/terraform.tfstate | jq -r '.outputs.test.value.service_principal_cluster_creator_client_id'` && \
		export CLUSTER_CREATOR_CLIENT_SECRET=`cat azure-ad-administrator/test/terraform.tfstate | jq -r '.outputs.test.value.service_principal_cluster_creator_client_secret'` && \
		export CONTROL_PLANE_SUBNET_ID=`cat network-administrator/test/terraform.tfstate | jq -r '.resources[] | select(.type == "azurerm_subnet" and .name == "control_plane") | .instances[0].attributes.id'` && \
		export WORKER_SUBNET_ID=`cat network-administrator/test/terraform.tfstate | jq -r '.resources[] | select(.type == "azurerm_subnet" and .name == "worker") | .instances[0].attributes.id'` && \
		cd cluster-creator/test && \
		terraform init && \
		terraform apply \
			-var="location=$(LOCATION)" \
			-var="cluster_name=$(CLUSTER_NAME)" \
			-var="resource_group_vnet=$(RESOURCE_GROUP_VNET)" \
			-var="control_plane_subnet_id=$${CONTROL_PLANE_SUBNET_ID}" \
			-var="worker_subnet_id=$${WORKER_SUBNET_ID}" \
			-var="resource_group_aro=$(RESOURCE_GROUP_ARO)" \
			-var="service_principal_cluster_client_id=$${CLUSTER_CLIENT_ID}" \
			-var="service_principal_cluster_client_secret=$${CLUSTER_CLIENT_SECRET}" \
			-var="service_principal_cluster_creator_client_id=$${CLUSTER_CREATOR_CLIENT_ID}" \
			-var="service_principal_cluster_creator_client_secret=$${CLUSTER_CREATOR_CLIENT_SECRET}" \
			-var="subscription_id=$$(az account show --query 'tenantId' -o tsv)" \
			-var="tenant_id=$$(az account show --query 'id' -o tsv)"


cluster-destroy:
	@cd azure-ad-administrator/test && terraform init && terraform apply -destroy
