module "monitor" {
  source = "registry.terraform.io/T-Systems-MMS/monitor/azurerm"
  monitor_diagnostic_setting = {
    virtual_network.name = {
      target_resource_id         = virtual_network.id
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
      enabled_metric = {
        category = ["AllMetrics"]
      }
    }
    frontdoor.name = {
      target_resource_id         = frontdoor.id
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
      enabled_log = {
        category = ["FrontdoorWebApplicationFirewallLog"]
      }
      enabled_metric = {
        category = ["AllMetrics"]
      }
    }
  }
}
