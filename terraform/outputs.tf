output "avd_session_host_ips" {
  value = azurerm_network_interface.avd_nic[*].private_ip_address
}
