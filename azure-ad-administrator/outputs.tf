#
# WARN: normally these would be sensitive = true, however, for demo purposes we
#       will allow this to be configurable.
#
output "service_principal_cluster_client_id" {
  value = azuread_application.cluster.application_id
}

output "service_principal_cluster_client_secret" {
  value = azuread_application_password.cluster.value
}

output "service_principal_cluster_creator_client_id" {
  value = azuread_application.cluster_creator.application_id
}

output "service_principal_cluster_creator_client_secret" {
  value = azuread_application_password.cluster_creator.value
}
