output "connection_string" {
    value = replace(azurerm_cosmosdb_account.cosmosdb_account.connection_strings[0],"10255/","10255/phaserQuest")
}