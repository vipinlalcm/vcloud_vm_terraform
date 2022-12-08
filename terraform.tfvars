
# VDC Objects

vcd_org = "CKP"
vcd_vdc = "[east-1b] CKP vDC"
vcd_url = "https://vcloud1.test.io/api"
# vcd_auth_type = "integrated"
vapp_name = "rancher-cluster"

### Network Objects ###
vcd_edge_gateway_name = "[east-1b] CKP EGW"
public_ipaddress      = "192.168.0.1"
network_name          = "192.168.0.X"

### VM Objects ###
vapp_catalog_name   = "vApp_Templates Catalog"
vapp_template_name  = "Ubuntu 22.04 Cloudimage"
vm_memory           = 1024
vm_cpus             = 2
vm_cpu_cores        = 1
vm_os_type          = "Ubuntu Linux (64-bit)"
vm_hardware_version = "vmx-15"
computer_name       = "rancher-machine"
vm_name             = "rancher-cluster-node"
