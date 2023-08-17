# Network Administrator

This bit of Terraform as it relates to ARO is responsible for a few key items:

1. Create the *VNET Resource Group* (if requested)
2. Create the *ARO VNET*
3. Create the *ARO Control Plane Subnet*
4. Create the *ARO Machine Subnet*

This module should be run as a network administrator user.  Real world scenarios
would likely have more complex deployments.  This is simply a simulation to show
separation of duties.
