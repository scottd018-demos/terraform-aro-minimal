# Summary

This bit of Terraform as it relates to ARO is responsible for a few key items:

1. Register the Provider(s)
2. Create the *Cluster Creator Service Principal*
3. Create the *Cluster Service Principal*
4. Assign permissions on things like VNET, Resource Group, etc. if requested

This module should be run as an administrative user.  It should be thought of as 
a setup step prior to running the actual cluster creation.
