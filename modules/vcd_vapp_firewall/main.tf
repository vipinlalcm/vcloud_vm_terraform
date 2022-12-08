resource "random_integer" "random_original_port" {
  for_each = toset(var.enable_ports)
  min      = 2000
  max      = 3000
  keepers = {
    translated_port = each.key
  }
}
resource "vcd_nsxv_dnat" "vm-dnat" {
  for_each           = random_integer.random_original_port
  edge_gateway       = var.get_edge_gateway_name
  network_name       = var.get_vcd_nsxv_dnat_network_name
  network_type       = "ext"
  enabled            = true
  description        = "DNAT port '${each.value.result}' for ${var.get_vm_name}"
  original_address   = var.get_vcd_nsxv_firewall_rule_public_ipaddress
  original_port      = each.value.result
  translated_address = var.get_vm_ip
  translated_port    = each.value.keepers.translated_port
  protocol           = "tcp"

  # lifecycle {
  #   ignore_changes = [
  #     original_port,
  #     translated_address,
  #     translated_port

  #   ]
  # }

}
locals {
  service = flatten([for srv in vcd_nsxv_dnat.vm-dnat : [
    {
      port = srv.original_port
    }
    ]
  ])
}
resource "vcd_nsxv_firewall_rule" "vm-rules" {
  edge_gateway = var.get_edge_gateway_name
  source {
    ip_addresses = var.get_source_allowed_ipaddress
  }
  destination {
    ip_addresses = ["${var.get_vcd_nsxv_firewall_rule_public_ipaddress}"]
  }

  name = "Allow rules for ${var.get_vm_name}"

  dynamic "service" {
    for_each = local.service
    content {
      protocol = "tcp"
      port     = service.value.port
    }
  }
  # lifecycle {
  #   ignore_changes = [
  #     service,
  #     source
  #   ]
  # }

}

locals {
  host_groups = flatten([for obj in vcd_nsxv_dnat.vm-dnat :
    obj.translated_port == "22" ? {
      ssh_port = obj.original_port
      hostname = var.get_vm_name
      /*
      admin_password attribunte is no more used
      */
      # admin_password = nonsensitive(var.admin_password)
    } : null

  ]).0
}
output "host_groups" {
  value = local.host_groups
}
