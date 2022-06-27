resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.servicebus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.servicebus_sku
  tags                = var.tags
}

#service bus topics. Add more topic using this sample below
resource "azurerm_servicebus_topic" "servicebus_topic_example" {
  name                  = "cloudsetup-example-topic"
  namespace_id          = azurerm_servicebus_namespace.servicebus.id
  max_size_in_megabytes = 1024 #1MB. Increase the size according to your need   
}

#subscription for the topic
resource "azurerm_servicebus_subscription" "servicebus_subscription_example" {
  name               = "cloudsetup-example-topic-subscription"
  topic_id           = azurerm_servicebus_topic.servicebus_topic_example.id
  max_delivery_count = 10
}

#subscription rule
resource "azurerm_servicebus_subscription_rule" "servicebus_topic_rule_example" {
  name            = "AzureCloudsetupExmapleConfig"
  subscription_id = azurerm_servicebus_subscription.servicebus_subscription_example.id
  filter_type     = "SqlFilter"
  sql_filter      = "MessageType = 'ExampleNotification'" #example notification is your message type received
}
