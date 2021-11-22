# Create a resource group

resource "azurerm_resource_group" "k8s" {
  name     = var.rg_name
  location = var.location
}

# Create managed postgresql database

resource "azurerm_postgresql_server" "postgresql" {
  name                = "wt-psqlserver-${var.env}"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name

  administrator_login          = var.pg_user
  administrator_login_password = var.pg_password

  sku_name   = "B_Gen5_1"
  version    = "11"
  storage_mb = 5120

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  public_network_access_enabled = true
  ssl_enforcement_enabled       = false
}

# Create new database

resource "azurerm_postgresql_database" "wt_db" {
  name                = var.pg_database
  resource_group_name = azurerm_resource_group.k8s.name
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

# Create container registry

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Create AKS cluster

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.agent_count
    vm_size    = "Standard_B2s"
  }

  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet"
  }

  tags = {
    Environment = "Production"
  }
}