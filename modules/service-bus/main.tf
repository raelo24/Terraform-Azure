resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.servicebus_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.servicebus_sku
  tags                = var.tags
}

locals {
  topics = {
    for i in var.topic_subscriptions : i.topic => i
  }

  #-  
  #- Formatting for subscription => topic mapping for each subsription
  #- Thanks to idea from https://www.reddit.com/r/Terraform/comments/tbai8o/comment/i05y74u/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

  //first create a tuple with 2 elements
  tuple = flatten([
    for details in local.topics : [
      for sub in details.subscriptions : {
        topic        = details.topic
        subscription = sub
      }
    ]
  ])

  //next create the mapping from the tuple
  subscriptions = {
    for details in local.tuple :
    details.subscription => details.topic
  }
}

#service bus topics. Add more topic using this sample below
resource "azurerm_servicebus_topic" "topics" {
  for_each              = local.topics
  name                  = each.key
  namespace_id          = azurerm_servicebus_namespace.servicebus.id
  max_size_in_megabytes = var.max_size
  depends_on            = [azurerm_servicebus_namespace.servicebus]
}

resource "azurerm_servicebus_subscription" "subscriptions" {
  for_each           = local.subscriptions
  name               = each.key
  topic_id           = azurerm_servicebus_topic.topics[each.value].id
  max_delivery_count = var.max_delivery_count
  depends_on         = [azurerm_servicebus_topic.topics]
}
