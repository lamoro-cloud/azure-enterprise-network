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
resource "azurerm_network_security_group" "Security_Portafolio" {
      name = "nsg-portafolio-seguro"
      location = azurerm_resource_group.mi_grupo.location
      resource_group_name = azurerm_resource_group.mi_grupo.name
}
# 5. La Regla: El agujero en el escudo para tu llave SSH
resource "azurerm_network_security_rule" "regla_ssh" {
  name                        = "Permitir-SSH-Desde-Mi-Casa"
  priority                    = 100                     
  direction                   = "Inbound"               
  access                      = "Allow"                 
  protocol                    = "Tcp"                   
  source_port_range           = "*"                     
  destination_port_range      = "22"                    
  source_address_prefix       = "*"                     
  destination_address_prefix  = "*"                     
  resource_group_name         = azurerm_resource_group.mi_grupo.name
  network_security_group_name = azurerm_network_security_group.Security_Portafolio.name
}
# 6. Enchufar el escudo a nuestra habitación (Subred)
resource "azurerm_subnet_network_security_group_association" "conectar_cerrojo" {
  subnet_id                 = azurerm_subnet.mi_subred.id
  network_security_group_id = azurerm_network_security_group.Security_Portafolio.id
}