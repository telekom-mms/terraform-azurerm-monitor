output "monitor_diagnostic_setting" {
  description = "Outputs all attributes of azurerm_monitor_diagnostic_setting."
  value = {
    for monitor_diagnostic_setting in keys(azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting) :
    monitor_diagnostic_setting => {
      for key, value in azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting[monitor_diagnostic_setting] :
      key => value
    }
  }
}

output "monitor_action_group" {
  description = "Outputs all attributes of azurerm_monitor_action_group."
  value = {
    for monitor_action_group in keys(azurerm_monitor_action_group.monitor_action_group) :
    monitor_action_group => {
      for key, value in azurerm_monitor_action_group.monitor_action_group[monitor_action_group] :
      key => value
    }
  }
}

output "monitor_activity_log_alert" {
  description = "Outputs all attributes of azurerm_monitor_activity_log_alert."
  value = {
    for monitor_activity_log_alert in keys(azurerm_monitor_activity_log_alert.monitor_activity_log_alert) :
    monitor_activity_log_alert => {
      for key, value in azurerm_monitor_activity_log_alert.monitor_activity_log_alert[monitor_activity_log_alert] :
      key => value
    }
  }
}

output "monitor_scheduled_query_rules_alert" {
  description = "Outputs all attributes of azurerm_monitor_scheduled_query_rules_alert."
  value = {
    for monitor_scheduled_query_rules_alert in keys(azurerm_monitor_scheduled_query_rules_alert.monitor_scheduled_query_rules_alert) :
    monitor_scheduled_query_rules_alert => {
      for key, value in azurerm_monitor_scheduled_query_rules_alert.monitor_scheduled_query_rules_alert[monitor_scheduled_query_rules_alert] :
      key => value
    }
  }
}

output "variables" {
  description = "Displays all configurable variables passed by the module. __default__ = predefined values per module. __merged__ = result of merging the default values and custom values passed to the module"
  value = {
    default = {
      for variable in keys(local.default) :
      variable => local.default[variable]
    }
    merged = {
      monitor_diagnostic_setting = {
        for key in keys(var.monitor_diagnostic_setting) :
        key => local.monitor_diagnostic_setting[key]
      }
      monitor_action_group = {
        for key in keys(var.monitor_action_group) :
        key => local.monitor_action_group[key]
      }
      monitor_activity_log_alert = {
        for key in keys(var.monitor_activity_log_alert) :
        key => local.monitor_activity_log_alert[key]
      }
      monitor_scheduled_query_rules_alert = {
        for key in keys(var.monitor_scheduled_query_rules_alert) :
        key => local.monitor_scheduled_query_rules_alert[key]
      }
    }
  }
}
