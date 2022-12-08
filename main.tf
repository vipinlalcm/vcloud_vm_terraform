# Configure the VMware Cloud Director Provider
/*
  token                = var.vcd_token #(TF_VAR_vcd_token)
  auth_type            = var.vcd_auth_type #(default: integrated)
  user = VCD_USER
  password = VCD_PASSWORD

  Credentials are automatically fetched from env variables when the auth type is "integrated"
  
  NOTE: when you use auth type 'token'. You must add "TF_VAR_vcd_token" with the token. Then you have to spesify 
  "token" and "auth_type" arguments in the "provider" "vcd" (below)
*/

# Resource to create VApp
resource "vcd_vapp" "vm_vapp" {
  name     = var.vapp_name
  power_on = true
}

module "network_creation" {
  source                                      = "./modules/vcd_network"
  get_vapp_name                               = var.vapp_name
  get_edge_gateway_name                       = var.vcd_edge_gateway_name
  get_vcd_network_routed_name                 = "${var.vapp_name}-routed"
  get_vcd_vapp_network_name                   = "${var.vapp_name}-internal"
  get_vcd_network_routed_gateway_ip           = "10.231.223.1"
  get_vcd_network_routed_dns1_ip              = "10.231.223.1"
  get_vcd_network_routed_dns2_ip              = "193.108.1.50"
  get_vcd_network_routed_dhcp_start_address   = "10.231.223.2"
  get_vcd_network_routed_dhcp_end_address     = "10.231.223.30"
  get_vcd_network_routed_static_start_address = "10.231.223.31"
  get_vcd_network_routed_static_end_address   = "10.231.223.50"
  get_vcd_vapp_network_gateway_ip             = "10.231.222.1"
  get_vcd_vapp_network_netmask                = "255.255.255.224"
  get_vcd_vapp_network_dns1_ip                = "10.231.222.1"
  get_vcd_vapp_network_dns2_ip                = "193.108.1.50"
  get_vcd_vapp_network_dns_suffix             = "domain.root"
  get_vcd_vapp_network_dhcp_start_address     = "10.231.222.2"
  get_vcd_vapp_network_dhcp_end_address       = "10.231.222.10"
  get_vcd_vapp_network_static_start_address   = "10.231.222.11"
  get_vcd_vapp_network_static_end_address     = "10.231.222.20"
  depends_on = [
    vcd_vapp.vm_vapp
  ]
}

/*
Mandatory fields:
    * count
    * computer_name 
    * vm_name
    * vm_memory 
    * vm_cpus
    * vm_cpu_cores

Optional fields: (You may comment it or remove these lines if you don't need it)
    ? metadata            = { ansible_group = "worker" } [VM metadata for ansible inventory]
    ? vapp_network_enable    = false [create or skip vapp network for VM]
    ? override_template_disk = 51200 [whether override the default template disk]
    ? additional_disk = 10240 [whether attach additional disk to VM or not.]
    ? enable_ports = {
        ports  = ["22"]
        dnat_port_auto_increment_suffix = 0
        enabled                         = false
      } [ If it is enabled, firewall and DNAT rule will create for that group of VMs
        else it will not create any firewall and DNAT]
  */
locals {
  nodes = {
    master : {
      count               = 3,
      computer_name       = "${var.computer_name}-master",
      vm_name             = "${var.vm_name}-master",
      vm_memory           = 5120,
      vm_cpus             = 4,
      vm_cpu_cores        = 2,
      metadata            = { ansible_group = "control" },
      vapp_network_enable = true,
      override_template_disk = 51200,
      additional_disk        = 51200,

      enable_ports = {
        ports   = ["22", "80", "443"]
        enabled = true
      }
    },
    worker : {
      count         = 0,
      computer_name = "${var.computer_name}-worker",
      vm_name       = "${var.vm_name}-worker",
      vm_memory     = 1024,
      vm_cpus       = 2,
      vm_cpu_cores  = 1,
      # metadata            = { ansible_group = "worker" },
      vapp_network_enable    = true,
      override_template_disk = 51200,
      additional_disk        = 10240,
      enable_ports = {
        ports   = ["443", "80", "22"]
        enabled = true
      }

    },
    default : {
      count         = 1,
      computer_name = "${var.computer_name}-default",
      vm_name       = "${var.vm_name}-default",
      vm_memory     = 5120,
      vm_cpus       = 4,
      vm_cpu_cores  = 2,
      # metadata            = { ansible_group = "default" },
      vapp_network_enable = true,
      override_template_disk = 51200, 
      additional_disk = 10240,
      enable_ports = {
        ports   = ["22", "443"]
        enabled = true
      }

    },
    dns : {
      count         = 1,
      computer_name = "${var.computer_name}-dns",
      vm_name       = "${var.vm_name}-dns",
      vm_memory     = 1024,
      vm_cpus       = 2,
      vm_cpu_cores  = 1,
      # metadata            = { ansible_group = "default" },
      vapp_network_enable = false,
      # override_template_disk = 51200, 
      # additional_disk = 10240,
      enable_ports = {
        ports   = ["22"]
        enabled = true
      }

    }
  }
}

module "vcd_vapp" {
  source                                      = "./modules/vcd_vapp"
  get_org                                     = var.vcd_org
  get_vdc                                     = var.vcd_org
  get_vapp_name                               = var.vapp_name
  get_catalog_name                            = var.vapp_catalog_name
  get_template_name                           = var.vapp_template_name
  get_vcd_nsxv_dnat_network_name              = var.network_name
  get_vcd_nsxv_firewall_rule_public_ipaddress = var.public_ipaddress
  get_edge_gateway_name                       = var.vcd_edge_gateway_name
  get_vcd_network_routed_name                 = module.network_creation.routed_network_name
  get_vcd_vapp_network_name                   = module.network_creation.vapp_network_name
  get_source_allowed_ipaddress                = ["122.185.109.130", "193.108.5.135"]
  for_each                                    = local.nodes
  get_count                                   = each.value.count
  get_computer_name                           = each.value.computer_name
  get_vm_name                                 = each.value.vm_name
  get_memory                                  = each.value.vm_memory
  get_cpus                                    = each.value.vm_cpus
  get_cpu_cores                               = each.value.vm_cpu_cores
  get_additional_disk_size_in_mb              = lookup(each.value, "additional_disk", 0)
  get_override_template_disk_size_in_mb       = lookup(each.value, "override_template_disk", 0)
  enable_ports                                = lookup(each.value, "enable_ports", { ports = [], enabled = false })
  vapp_network_enable                         = lookup(each.value, "vapp_network_enable", false)
  get_metadata                                = lookup(each.value, "metadata", { role = "default" })
  depends_on = [
    vcd_vapp.vm_vapp,
    module.network_creation
  ]
}

locals {
  host_groups = [for group_key, group_value in module.vcd_vapp : {
    "${group_key}" = flatten([for key, value in module.vcd_vapp[group_key] :
      [for host_key, host_value in module.vcd_vapp[group_key] : host_value
    ]])
  }]

}

output "host_groups" {
  value = local.host_groups
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tftpl",
    {
      host_groups = local.host_groups
  })
  filename = "inventory.ini"
}