variable "name" {
    type        = string
    description = "The resource group name"  
}

variable "tags" {
    type        =  map
    description = "Tags of the resource" 
}

variable "location" {
    type        = string
    description = "The resource location on the cloud"
}