module "resource_group" {
  source   = "./modules/resource-group"
  name     = "${var.resource_group_base_name}-${var.env}"
  location = var.resource_group_location
  tags     = local.tags
}