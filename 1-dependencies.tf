locals {
  virtual_machine_name = "${var.prefix}-vm"
  admin_username       = "testadmin"
  admin_password       = "Password1234!"
}

resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = "${azurerm_resource_group.example.name}"
  virtual_network_name = "${azurerm_virtual_network.example.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "example" {
  name                = "${var.prefix}-publicip"
  resource_group_name = "${azurerm_resource_group.example.name}"
  location            = "${azurerm_resource_group.example.location}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.example.location}"
  resource_group_name = "${azurerm_resource_group.example.name}"

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${azurerm_subnet.example.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.2.5"
    public_ip_address_id          = "${azurerm_public_ip.example.id}"
  }
}

resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "${var.prefix}-nsg"
    location            = "${azurerm_resource_group.example.location}"
    resource_group_name = "${azurerm_resource_group.example.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Terraform Demo"
    }
    
    provisioner "local-exec" {
      command = "echo Hello from the agent"
    }
    provisioner "local-exec" {
      command = "echo ##vso[task.setvariable variable=ip]${azurerm_public_ip.example.ip_address}"
    }
}