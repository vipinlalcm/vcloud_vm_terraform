resource "vcd_network_routed" "rancher-cluster-routed-network" {
  edge_gateway = var.get_edge_gateway_name
  name         = var.get_vcd_network_routed_name
  gateway      = var.get_vcd_network_routed_gateway_ip
  dns1         = var.get_vcd_network_routed_dns1_ip
  dns2         = var.get_vcd_network_routed_dns2_ip
  dhcp_pool {
    start_address = var.get_vcd_network_routed_dhcp_start_address
    end_address   = var.get_vcd_network_routed_dhcp_end_address
  }
  static_ip_pool {
    start_address = var.get_vcd_network_routed_static_start_address
    end_address   = var.get_vcd_network_routed_static_end_address
  }
}

resource "vcd_vapp_network" "rancher-cluster-vapp-network" {
  vapp_name  = var.get_vapp_name
  name       = var.get_vcd_vapp_network_name
  gateway    = var.get_vcd_vapp_network_gateway_ip
  netmask    = var.get_vcd_vapp_network_netmask
  dns1       = var.get_vcd_vapp_network_dns1_ip
  dns2       = var.get_vcd_vapp_network_dns2_ip
  dns_suffix = var.get_vcd_vapp_network_dns_suffix
  dhcp_pool {
    start_address = var.get_vcd_vapp_network_dhcp_start_address
    end_address   = var.get_vcd_vapp_network_dhcp_end_address
  }
  static_ip_pool {
    start_address = var.get_vcd_vapp_network_static_start_address
    end_address   = var.get_vcd_vapp_network_static_end_address
  }
}

resource "vcd_vapp_org_network" "rancher-cluster-org-network" {
  vapp_name        = var.get_vapp_name
  org_network_name = vcd_network_routed.rancher-cluster-routed-network.name
}