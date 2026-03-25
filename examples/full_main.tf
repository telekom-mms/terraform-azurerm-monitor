data "azurerm_subscription" "current" {}

module "key_vault" {
  source = "registry.terraform.io/telekom-mms/key-vault/azurerm"
  key_vault = {
    kv-mms-github = {
      resource_group_name = "rg-mms-github"
      location            = "westeurope"
      tenant_id           = data.azurerm_subscription.current.tenant_id
      sku_name            = "standard"
    }
  }
}

module "log_analytics_workspace" {
  source = "registry.terraform.io/telekom-mms/log-analytics-workspace/azurerm"
  log_analytics_workspace = {
    law-mms-github = {
      resource_group_name = "rg-mms-github"
      location            = "westeurope"
    }
  }
}


module "monitor" {
  source = "registry.terraform.io/telekom-mms/monitor/azurerm"

  monitor_action_group = {
    ag-mms-github = {
      resource_group_name = "rg-mms-github"
      short_name          = "agmmsgithub"
      enabled             = true
      email_receiver = {
        sendtoadmin = {
          name                    = "sendtoadmin"
          email_address           = "admin@contoso.com"
          use_common_alert_schema = true
        }
      }
      tags = {
        project     = "mms-github"
        environment = "dev"
        managed-by  = "terraform"
      }
    }
  }

  monitor_diagnostic_setting = {
    diag-mms-github = {
      target_resource_id         = module.key_vault.key_vault["kv-mms-github"].id
      log_analytics_workspace_id = module.log_analytics_workspace.log_analytics_workspace["law-mms-github"].id
      enabled_log = {
        category = "AuditEvent"
      }
      enabled_metric = {
        category = "AllMetrics"
      }
    }
  }

  monitor_activity_log_alert = {
    ala-mms-github = {
      resource_group_name = "rg-mms-github"
      location            = "westeurope"
      scopes              = [data.azurerm_subscription.current.id]
      description         = "Alert for Service Health Recommendations"
      enabled             = true
      criteria = {
        category = "Recommendation"
        level    = "Informational"
      }
      action = {
        webhook_properties = {
          from = "terraform"
        }
      }
      tags = {
        project     = "mms-github"
        environment = "dev"
        managed-by  = "terraform"
      }
    }
  }

  monitor_scheduled_query_rules_alert = {
    sqra-mms-github = {
      resource_group_name     = "rg-mms-github"
      location                = "westeurope"
      data_source_id          = module.log_analytics_workspace.log_analytics_workspace["law-mms-github"].id
      query                   = "Perf | where ObjectName == \"Processor\" and CounterName == \"% Processor Time\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer"
      description             = "Alert for High CPU Usage"
      enabled                 = true
      severity                = 2
      throttling              = 5
      frequency               = 5
      time_window             = 5
      auto_mitigation_enabled = true
      trigger = {
        operator  = "GreaterThan"
        threshold = 80
        metric_trigger = {
          metric_column       = "Computer"
          metric_trigger_type = "Consecutive"
          operator            = "GreaterThan"
          threshold           = 1
        }
      }
      action = {
        action_group           = []
        email_subject          = "High CPU Alert"
        custom_webhook_payload = "{ \"alert\": \"#alertrulename\", \"metric\": \"#metricvalue\" }"
      }
      tags = {
        project     = "mms-github"
        environment = "dev"
        managed-by  = "terraform"
      }
    }
  }
}
