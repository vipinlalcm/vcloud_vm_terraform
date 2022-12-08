#### Declaring variables ####

## General ##
variable "get_org" {
  type        = string
  description = "Organisation name."
  default     = ""
}
variable "get_vdc" {
  type        = string
  description = "Organisation vdc."
  default     = ""
}
variable "get_vapp_name" {
  type        = string
  description = "The VApp name in which you need to create the VMs. (e.g. 'ckp_staging')."
  default     = ""
}

## Virtual Machine ##
variable "get_computer_name" {
  type        = string
  description = "The vapp_vm_computer_name name. (e.g. 'ckp-staging-worker-0')."
  default     = ""
}

variable "get_vm_name" {
  type        = string
  description = "The VM name in which you need to create the VMs. (e.g. 'ckp_staging')."
  default     = ""
}

variable "get_catalog_name" {
  type        = string
  description = "The vapp catalog name. (e.g. 'vApp_Templates Catalog')."
  default     = ""
}

variable "get_template_name" {
  type        = string
  description = "The os template name. (e.g. 'vApp_Ubuntu20')."
  default     = ""
}

variable "get_memory" {
  type        = number
  description = "The virtual machine memory. (e.g. 1024 MB)."
  default     = 1024
}

variable "get_cpus" {
  type        = number
  description = "The virtual machine cpu count. (e.g. 2)."
  default     = 2
}

variable "get_cpu_cores" {
  type        = number
  description = "The virtual machine cores per cpu (e.g. 1)."
  default     = 1
}

variable "get_memory_hot_add_enabled" {
  type        = bool
  description = "Enable memory hot add in vms."
  default     = true
}

variable "get_cpu_hot_add_enabled" {
  type        = bool
  description = "Enable cpu hot add in vms."
  default     = true
}

variable "get_metadata" {
  type        = map(string)
  description = "The metadata for vms. (e.g metadata = {role = 'master'})."
  default     = {}
}

variable "get_override_template_disk_size_in_mb" {
  type        = number
  description = "Getting override disk size."
  default     = 0
  nullable    = true
}
variable "get_additional_disk_name" {
  type        = string
  description = "vcd_independent_disk for vms. (e.g. {name=worker-0-disk})."
  default     = ""
  nullable    = true
}

variable "get_additional_disk_size_in_mb" {
  type        = number
  description = "Additional disk size."
  nullable    = true
}

### Network ###

## Routed Network ###
variable "get_edge_gateway_name" {
  type        = string
  default     = ""
  description = "VDC edge gateway name to create firewall and NAT rules."
}

### DNAT ###

variable "get_vcd_nsxv_dnat_network_name" {
  type        = string
  default     = ""
  description = "Network name to create NAT rules (e.g 81.91.13.X)."
}

variable "get_vcd_nsxv_firewall_rule_public_ipaddress" {
  type        = string
  description = "Public IP address (e.g. 81.91.13.189)."
  default     = ""

}
variable "enable_ports" {
  type = object({
    ports   = list(string)
    enabled = bool
  })
  description = "Custom variable for enabling firewall and NAT. When enabled=false, it will not add any firewall and NAT rule for that spesifc VM."
}


### Firewall ## 
variable "get_source_allowed_ipaddress" {
  type        = list(string)
  default     = ["122.185.109.130", "193.108.5.135"]
  description = "Source allow IP address for enabling the ports on firewall (e.g. ['122.185.109.130', '193.108.5.135'] )."

}

variable "get_count" {
  type        = number
  description = "count for the VMs to create the VM firewalls and NAT."

}

variable "vapp_network_enable" {
  type        = bool
  default     = false
  description = "Variable to check whether vapp network ip should add in spesific VM or not."

}

variable "get_vcd_network_routed_name" {
  type        = string
  description = "Org VDC routed network name."

}

variable "get_vcd_vapp_network_name" {
  type        = string
  description = "Org vapp network name."

}