resource "azurerm_mssql_server" "sqlserver" {
    name = "${var.sql_server_name}" 
    resource_group_name = "${var.resource_group_name}"
    location = "${var.location}"
    version = "${var.sql_server_version}"
    minimum_tls_version = "1.2"
    administrator_login = "${var.sql_server_admin_username}"
    administrator_login_password = "${var.sql_server_admin_password}"
    tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "db_firewall" {
    name = "fw_AllowAzureService" 
    start_ip_address = "0.0.0.0" 
    end_ip_address = "0.0.0.0"
    server_id = azurerm_mssql_server.sqlserver.id
}

resource "azurerm_mssql_database" "sqlserver_db" {
    for_each = toset(var.database_list)
    name = "${each.value}"
    server_id = azurerm_mssql_server.sqlserver.id
    collation = "${var.sql_database_collation}"
    sku_name = "${var.sql_database_sku_name}"
    tags = var.tags
    zone_redundant = false
    read_scale = false
}

