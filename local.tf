locals {
  org          = "cloudsetup"
  domain       = "mydomain.com"
  
  tags = {
    Terraform   = "true"
    Environment = "${var.env}"
    Owner       = local.org
  }
}