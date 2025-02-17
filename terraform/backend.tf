terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-backend-rg"
    storage_account_name  = "terraformbackendsa"
    container_name        = "tfstate"
    key                   = "avd/terraform.tfstate"
  }
}
