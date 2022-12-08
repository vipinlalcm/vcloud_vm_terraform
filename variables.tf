##### VCD (VMware Cloud Director) or vcloud ####

#### Declaring variables ####
variable "vcd_auth_type" {
  type        = string
  description = "The vcloud authentication type. (e.g. 'token' or 'integrated')"
  default     = "integrated"
  sensitive   = true
}

variable "vcd_user" {
  type        = string
  description = "The vcloud authentication user. (e.g. 'administrator' or 'execuser' )"
  default     = ""
  sensitive   = true

}

variable "vcd_pass" {
  type        = string
  description = "The vcloud password. (e.g. 'MyStrongPassword')"
  default     = ""
  sensitive   = true
}

variable "vcd_token" {
  type        = string
  description = <<EOF
    Token can be generated by the get_token.sh script in this repo.

    or 

    use: https://registry.terraform.io/providers/vmware/vcd/latest/docs#shell-script-to-obtain-token

    You can find the header "X-VMWARE-VCLOUD-ACCESS-TOKEN" in the output of the above script and that value
    should be used as token.
  EOF
  default     = ""
  sensitive   = true
}

variable "vcd_org" {
  type        = string
  description = "The vcloud organisation name. (e.g. 'Test' or 'Telia')"
  default     = ""
}

variable "vcd_vdc" {
  type        = string
  description = "The vcloud virtual data center. (e.g. '[east-1a] TestABPKIAO741TEST vDC')"
  default     = ""
}

variable "vcd_url" {
  type        = string
  description = "The api endpoint url for terraform to run the tasks. (e.g. 'https://vloudipaddress/api')"
}

variable "vcd_max_retry_timeout" {
  type        = number
  description = <<EOF
  This provides you with the ability to specify the maximum amount of time (in seconds) you are prepared 
  to wait for interactions on resources managed by Cloud Director to be successful
  EOF
  default     = 60
}

variable "vcd_allow_unverified_ssl" {
  type        = bool
  description = "Boolean that can be set to true to disable SSL certificate verification."
  default     = false
}

variable "vapp_name" {
  type        = string
  description = "The VApp name in which you need to create the VMs. (e.g. 'ckp_staging')"
  default     = ""
}

variable "vcd_edge_gateway_name" {
  type        = string
  description = "The routed org vdc network edge gateway name in the VDC. (e.g. '[east-1a] TestABPKIAO741TEST EGW')"
  default     = ""
}

variable "vapp_catalog_name" {
  type        = string
  description = "The vapp catalog name. (e.g. 'vApp_Templates Catalog')"
  default     = ""
}

variable "vapp_template_name" {
  type        = string
  description = "The os template name. (e.g. 'vApp_Ubuntu20')"
  default     = ""
}

variable "vm_memory" {
  type        = number
  description = "The virtual machine memory. (e.g. 1024 MB)"
  default     = 1024
}

variable "vm_cpus" {
  type        = number
  description = "The virtual machine cpu count. (e.g. 2)"
  default     = 2
}

variable "control_vm_memory" {
  type        = number
  description = "The virtual machine memory. (e.g. 1024 MB)"
  default     = 1024
}

variable "control_vm_cpus" {
  type        = number
  description = "The virtual machine cpu count. (e.g. 2)"
  default     = 2
}

variable "vm_cpu_cores" {
  type        = number
  description = "The virtual machine cores per cpu (e.g. 1)"
  default     = 1
}


variable "public_ipaddress" {
  type        = string
  description = "Public IP address (e.g. 81.91.13.189)"
  default     = "81.91.13.189"

}

variable "network_name" {
  type        = string
  description = "Network Name (e.g. 81.91.13.X)"
  default     = "81.91.13.X"

}

variable "vm_os_type" {
  type        = string
  description = "VMware VirtualMachineGuestOsIdentifier"
  default     = ""
}
variable "vm_hardware_version" {
  type        = string
  description = "VMware hw version"
  default     = "vmx-15"
}

variable "computer_name" {
  type        = string
  description = "Virtual Machine computer name"

}

variable "vm_name" {
  type        = string
  description = "Virtual Machine name"

}