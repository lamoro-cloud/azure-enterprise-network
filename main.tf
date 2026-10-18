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
# 7. Maquina virtual Linux server
resource "azurerm_linux_virtual_machine" "servidor" {
  name = "vm-portfolio_devops"
  location = azurerm_resource_group.mi_grupo.location
  resource_group_name = azurerm_resource_group.mi_grupo.name
  size = "standar_B1ls" # El tamaño más pequeñito y barato de Azure, ideal para aprender
  admin_username = "adminuser" # El nombre de usuario para entrar al ordenador
  # Interface de red
  network_interface_ids = [ azurerm_network_interface.mi_tarjeta_red.id 
  ]}
  # Key que usa
  admin_ssh_key {
    username = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub") # Va a buscar el candado a tu carpeta oculta
  }
os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS" # Disco estándar económico
  }
 # Qué sistema operativo le instalamos (Ubuntu Linux 22.04 LTS)
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }



# 8. La tarjeta de red (El cable para enchufar el servidor a tu subred)
resource "azurerm_network_interface" "mi_tarjeta_red" {
  name                = "nic-portfolio-servidor"
  location            = azurerm_resource_group.mi_grupo.location
  resource_group_name = azurerm_resource_group.mi_grupo.name

  ip_configuration {
    name                          = "config-ip-interna"
    subnet_id                     = azurerm_subnet.mi_subred.id # Lo metemos en tu habitación protegida
    private_ip_address_allocation = "Dynamic"
  }
}
  
