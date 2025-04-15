provider "azurerm" {
  features {}
  subscription_id = "c1ff822a-8d32-49f1-b97a-89c2b2a1b55e"
}

resource "azurerm_resource_group" "main" {
  name     = "my-rg"
  location = "East US 2"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aksclusterbrijesh123"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "myaks"

#   default_node_pool {
#     name       = "default"
#     node_count = 1
#     vm_size    = "Standard_DS2_v2"
#   }

  default_node_pool {
  name       = "default"
  node_count = 1
  vm_size    = "Standard_B2s"
}


  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "acrbrijesh123"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true
}
