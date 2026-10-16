resource "azurerm_resource_group" "mi_grupo" {
    name  = "rg-portfolio-redes"
    location = "northeurope"
}
resource "azurerm_virtual_network" "mi_red" {
  name = "vnet-portfolio-principal"
  location = azurerm_resource_group.mi_grupo.location
  resource_group_name = azurerm_resource_group.mi_grupo.name
  address_space = ["10.0.0.0/16"
  ]
}
resource "azurerm_subnet" "mi_subred" {
    name = "sub-backend-principal"
  resource_group_name = azurerm_resource_group.mi_grupo.name
  virtual_network_name = azurerm_virtual_network.mi_red.name
  address_prefixes = ["10.0.1.0/24"]
}