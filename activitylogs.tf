resource "random_string" "storageaccount_name" {
    length  = 22
    upper   = false
    special = false
}
resource "azurerm_resource_group" "log" {
  name      = "${var.resource_group_name}"
  location  = "${var.location}"
}

resource "azurerm_storage_account" "log" {
  name                     = "subscriptionlogs-${random_string.storageaccount_name.result}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_eventhub_namespace" "log" {
  name                = "subscriptionlogs--${random_string.storageaccount_name.result}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  sku                 = "Standard"
  capacity            = 2
}
resource "azurerm_monitor_log_profile" "subscription" {
  name = "default"

  categories = [
    "Action",
    "Delete",
    "Write"
  ]

# Add all regions - > put in variable
  locations = [
    "eastus2",
    "westus",
    "centralus",
    "centralindia",
    "koreacentral",
    "canadaeast",
    "canadacentral",
    "brazilsouth",
    "francecentral",
    "westcentralus",
    "australiacentral",
    "northcentralus",
    "uksouth",
    "francesouth",
    "japanwest",
    "global",
    "southindia",
    "australiaeast",
    "ukwest",
    "eastus",
    "northeurope",
    "australiacentral2",
    "westeurope",
    "westus2",
    "southeastasia",
    "eastasia",
    "westindia",
    "japaneast",
    "southcentralus",
    "australiasoutheast",
    "koreasouth"
  ]

# RootManageSharedAccessKey is created by default with listen, send, manage permissions
servicebus_rule_id = "${azurerm_eventhub_namespace.log.id}/authorizationrules/RootManageSharedAccessKey"
storage_account_id = "${azurerm_storage_account.log.id}"

  retention_policy {
    enabled = true
    days    = 0 #infinite retention
  }
 
}