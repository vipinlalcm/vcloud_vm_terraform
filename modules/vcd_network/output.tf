output "routed_network_name" {
  value = vcd_network_routed.rancher-cluster-routed-network.name
}

output "vapp_network_name" {
  value = vcd_vapp_network.rancher-cluster-vapp-network.name
}