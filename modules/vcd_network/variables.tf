
#### Declaring variables ####

## General ##

variable "get_vapp_name" {
  type        = string
  description = "The VApp name in which you need to create the VMs. (e.g. 'ckp_staging')"
  default     = ""
}

### Network ###

## Routed Network ###
variable "get_edge_gateway_name" {
  type        = string
  default     = ""
  description = "VDC edge gateway name to create firewall and NAT rules."
}

variable "get_vcd_network_routed_gateway_ip" {
  type        = string
  default     = ""
  description = "Gateway ipaddress for the org routed network."
}
variable "get_vcd_network_routed_dns1_ip" {
  type        = string
  default     = ""
  description = "DNS1 ipaddress for the org routed network."
}
variable "get_vcd_network_routed_dns2_ip" {
  type        = string
  default     = ""
  description = "DNS2 ipaddress for the org routed network."
}
variable "get_vcd_network_routed_dhcp_start_address" {
  type        = string
  default     = ""
  description = "DHCP start address for the org routed network."
}
variable "get_vcd_network_routed_dhcp_end_address" {
  type        = string
  default     = ""
  description = "DHCP end address for the org routed network."
}
variable "get_vcd_network_routed_static_start_address" {
  type        = string
  default     = ""
  description = "Static network ip pool start address for the routed network."
}
variable "get_vcd_network_routed_static_end_address" {
  type        = string
  default     = ""
  description = "Static network ip pool end address for the routed network."
}

### Vapp Network ###

variable "get_vcd_vapp_network_gateway_ip" {
  type        = string
  default     = ""
  description = "Gateway ipaddress for the vapp network."
}
variable "get_vcd_vapp_network_netmask" {
  type        = string
  default     = ""
  description = "Subnetmask address for the vpp network."
}
variable "get_vcd_vapp_network_dns1_ip" {
  type        = string
  default     = ""
  description = "DNS1 ipaddress for the vapp network."
}
variable "get_vcd_vapp_network_dns2_ip" {
  type        = string
  default     = ""
  description = "DNS2 ipaddress for the vapp network."
}
variable "get_vcd_vapp_network_dns_suffix" {
  type        = string
  default     = ""
  description = "DNS suffix address for the vapp network (e.g 'domain.root')"
}
variable "get_vcd_vapp_network_dhcp_start_address" {
  type        = string
  default     = ""
  description = "DHCP start address for the vapp network."
}
variable "get_vcd_vapp_network_dhcp_end_address" {
  type        = string
  default     = ""
  description = "DHCP end address for the vapp network."
}
variable "get_vcd_vapp_network_static_start_address" {
  type        = string
  default     = ""
  description = "Static ip pool start address for the vapp network."
}
variable "get_vcd_vapp_network_static_end_address" {
  type        = string
  default     = ""
  description = "Static ip pool end address for the vapp network."
}

variable "get_vcd_network_routed_name" {
  type        = string
  description = "Org routed network name"
}

variable "get_vcd_vapp_network_name" {
  type        = string
  description = "VCD vapp network name (e.g 'internal-network')"

}