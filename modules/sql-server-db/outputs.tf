output "servername" {
    value =  azurerm_mssql_server.sqlserver.fully_qualified_domain_name
    description = "SQL server name"
}
