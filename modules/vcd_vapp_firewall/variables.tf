
### Network ###

## Routed Network ###
variable "get_edge_gateway_name" {
  type        = string
  description = "VDC edge gateway name to create firewall and NAT rules."
}

### DNAT ###

variable "get_vcd_nsxv_dnat_network_name" {
  type        = string
  description = "Network name to create NAT rules (e.g 81.91.13.X)"
  default     = ""

}

variable "get_vcd_nsxv_firewall_rule_public_ipaddress" {
  type        = string
  description = "Public IP address (e.g. 81.91.13.189)"
  default     = ""

}

variable "enable_ports" {
  type        = list(string)
  description = "DNAT port for SSH connection (e.g. 222)"
  default     = ["22"]
  nullable    = true
}


### Firewall ## 
variable "get_source_allowed_ipaddress" {
  type        = list(string)
  default     = []
  description = "Source allow IP address for enabling the ports on firewall (e.g. ['122.185.109.130', '193.108.5.135'] )"

}

variable "get_vm_name" {
  type        = string
  description = "Virtual machine name to add the description in the NAT and Firewall rules"

}
variable "get_vm_ip" {
  type        = string
  description = "Virtual machine org routed network IP to forward the traffic."

}
/*
admin_password attribunte is no more used
*/
# variable "admin_password" {
#   type      = string
#   sensitive = true

# }
