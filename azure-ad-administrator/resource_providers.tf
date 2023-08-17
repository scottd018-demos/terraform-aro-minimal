#
# azure providers
#
locals {
  enabled_providers = compact([
    for provider, enabled in {
      "Microsoft.RedHatOpenShift" : var.manage_openshift_provider,
      "Microsoft.Compute" : var.manage_compute_provider,
      "Microsoft.Storage" : var.manage_storage_provider,
      "Microsoft.Authorization" : var.manage_authorization_provider,
    } : (enabled ? provider : null)
  ])
}

resource "azurerm_resource_provider_registration" "aro_required_providers" {
  count = length(local.enabled_providers)

  name = local.enabled_providers[count.index]
}
