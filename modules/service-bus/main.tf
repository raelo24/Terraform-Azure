resource "azurerm_servicebus_namespace" "servicebus" {
  name                    = var.servicebus_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku                     = var.servicebus_sku
  tags                    = var.tags
}

#service bus topics. Add more topic using this sample below
resource "azurerm_servicebus_topic" "servicebus_topic_example" {
  name                    = "cloudsetup-example-topic"
  resource_group_name     = var.resource_group_name
  namespace_name          = azurerm_servicebus_namespace.servicebus.name
  max_size_in_megabytes   = 1024 #1MB. Increase the size according to your need   
}

#subscription for the topic
resource "azurerm_servicebus_subscription" "servicebus_subscription_example" {
  name                    = "cloudsetup-example-topic-subscription"
  topic_name              = "cloudsetup-example-topic"
  max_delivery_count      = 10
  resource_group_name     = var.resource_group_name
  namespace_name          = azurerm_servicebus_topic.servicebus_topic_example.name
}
