locals {
  override_template_disk = (var.get_override_template_disk_size_in_mb != 0 ? [{
    size_in_mb = var.get_override_template_disk_size_in_mb
  }] : [])
}

locals {
  networks = var.vapp_network_enable ? [
    {
      type               = "org",
      is_primary         = true,
      name               = var.get_vcd_network_routed_name
      ip_allocation_mode = "POOL"
    },
    {
      type               = "vapp",
      is_primary         = false,
      name               = var.get_vcd_vapp_network_name
      ip_allocation_mode = "DHCP"
    }
    ] : [
    {
      type               = "org",
      is_primary         = true,
      name               = var.get_vcd_network_routed_name
      ip_allocation_mode = "POOL"
    }
  ]
}
resource "vcd_vapp_vm" "vapp_vm" {
  count                  = var.get_count
  vapp_name              = var.get_vapp_name
  computer_name          = "${var.get_computer_name}-${count.index}"
  name                   = "${var.get_vm_name}-${count.index}"
  catalog_name           = var.get_catalog_name
  template_name          = var.get_template_name
  memory                 = var.get_memory
  cpus                   = var.get_cpus
  cpu_cores              = var.get_cpu_cores
  memory_hot_add_enabled = var.get_memory_hot_add_enabled
  cpu_hot_add_enabled    = var.get_cpu_hot_add_enabled
  metadata               = var.get_metadata



  dynamic "network" {
    /*
    This is a dynamic block which will loop through the local variable (Which is decleared above) and assign the values from it.
    */
    for_each = local.networks
    content {
      name               = network.value.name
      type               = network.value.type
      is_primary         = network.value.is_primary
      ip_allocation_mode = network.value.ip_allocation_mode
      adapter_type       = "VMXNET3"
      connected          = true
    }
  }
  dynamic "override_template_disk" {
    for_each = local.override_template_disk
    content {
      size_in_mb      = override_template_disk.value.size_in_mb
      bus_type        = "paravirtual"
      bus_number      = 0
      unit_number     = 0
      iops            = 0
      storage_profile = "Premium 02 Tier"
    }
  }

  dynamic "disk" {
    for_each = vcd_independent_disk.additional_disks
    content {
      name        = vcd_independent_disk.additional_disks[count.index].name
      bus_number  = 1
      unit_number = 0
    }
  }

  guest_properties = {
    "instance-id" = "${var.get_vm_name}-${count.index}"
    "hostname"    = "${var.get_vm_name}-${count.index}"
    "user-data"   = base64encode(file("${path.module}/cloud-config.yaml"))
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      cpus,
      memory,
      cpu_cores,
    ]
  }
}

resource "vcd_independent_disk" "additional_disks" {
  count           = var.get_additional_disk_size_in_mb != 0 ? var.get_count : 0
  name            = "${var.get_vm_name}-disk-${count.index}"
  size_in_mb      = var.get_additional_disk_size_in_mb != 0 ? var.get_additional_disk_size_in_mb : null
  bus_type        = "SCSI"
  bus_sub_type    = "VirtualSCSI"
  storage_profile = "Premium Tier"
  lifecycle {
    ignore_changes = [
      storage_profile,
      name
    ]
  }
}

module "firewall_nat" {
  source                                      = "../vcd_vapp_firewall"
  count                                       = var.enable_ports["enabled"] ? var.get_count : 0
  get_edge_gateway_name                       = var.get_edge_gateway_name
  get_vcd_nsxv_dnat_network_name              = var.get_vcd_nsxv_dnat_network_name
  get_vcd_nsxv_firewall_rule_public_ipaddress = var.get_vcd_nsxv_firewall_rule_public_ipaddress
  enable_ports                                = var.enable_ports["ports"]
  get_source_allowed_ipaddress                = var.get_source_allowed_ipaddress
  get_vm_name                                 = vcd_vapp_vm.vapp_vm[count.index].name
  /*
  admin_password attribunte is no more used
  */
  # admin_password                              = vcd_vapp_vm.vapp_vm[count.index].customization.0["admin_password"]

  /*
  Below get_vm_ip code is extracting the org network dynamically. 
  flatten output will be a list, that is why .0 is added at end to - 
  get the first element of list in string format to pass it to DNAT translated_address 
  */
  get_vm_ip = flatten([for interface in vcd_vapp_vm.vapp_vm[count.index].network[*] :
    interface.type == "org" ? interface.ip : ""
  ]).0
}

output "ansible_host_groups" {
  value = module.firewall_nat[*].host_groups
}

# output "all_output" {
#   value = flatten([for interface in vcd_vapp_vm.vapp_vm[*].network[*] : [
#     for nic in interface : (nic.type == "org" ? nic.type : "")]
#   ])
# }