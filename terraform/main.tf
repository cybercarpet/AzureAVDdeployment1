provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "avd_rg" {
  name     = "avd-resource-group"
  location = "Central Europe"
}

resource "azurerm_virtual_network" "avd_vnet" {
  name                = "avd-vnet"
  location            = azurerm_resource_group.avd_rg.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "avd_subnet" {
  name                 = "avd-subnet"
  resource_group_name  = azurerm_resource_group.avd_rg.name
  virtual_network_name = azurerm_virtual_network.avd_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_avd_host_pool" "avd_pool" {
  name                = "avd-host-pool"
  location            = azurerm_resource_group.avd_rg.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  type                = "Pooled"
}

resource "azurerm_avd_application_group" "avd_app_group" {
  name                = "avd-app-group"
  location            = azurerm_resource_group.avd_rg.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  host_pool_id        = azurerm_avd_host_pool.avd_pool.id
  type                = "Desktop"
}

resource "azurerm_automation_account" "auto_shutdown" {
  name                = "avd-auto-shutdown"
  location            = azurerm_resource_group.avd_rg.location
  resource_group_name = azurerm_resource_group.avd_rg.name
  sku_name            = "Basic"
}

resource "azurerm_automation_runbook" "shutdown_vms" {
  name                    = "Shutdown-AVD-VMs"
  location                = azurerm_resource_group.avd_rg.location
  resource_group_name      = azurerm_resource_group.avd_rg.name
  automation_account_name  = azurerm_automation_account.auto_shutdown.name
  log_verbose             = true
  log_progress            = true
  description             = "Automatically shuts down AVD VMs at night"
  runbook_type            = "PowerShell"
  content                 = <<EOT
    param(
      [string] $ResourceGroupName = "avd-resource-group"
    )
    $vms = Get-AzVM -ResourceGroupName $ResourceGroupName
    foreach ($vm in $vms) {
      Stop-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Force
    }
  EOT
}

resource "azurerm_monitor_action_group" "avd_alerts_action_group" {
  name                = "avd-alerts-group"
  resource_group_name = azurerm_resource_group.avd_rg.name
  short_name          = "avdalerts"

  email_receiver {
    name          = "AdminNotification"
    email_address = "admin@mockemail.com"
  }
}

resource "azurerm_monitor_metric_alert" "avd_cpu_alert" {
  name                = "avd-cpu-alert"
  resource_group_name = azurerm_resource_group.avd_rg.name
  scopes              = [azurerm_avd_host_pool.avd_pool.id]
  description         = "Alert when CPU usage exceeds 80%"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.avd_alerts_action_group.id
  }
}

resource "azurerm_monitor_metric_alert" "avd_memory_alert" {
  name                = "avd-memory-alert"
  resource_group_name = azurerm_resource_group.avd_rg.name
  scopes              = [azurerm_avd_host_pool.avd_pool.id]
  description         = "Alert when Memory usage exceeds 75%"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 25
  }

  action {
    action_group_id = azurerm_monitor_action_group.avd_alerts_action_group.id
  }
}
