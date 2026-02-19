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
    }
  }

  monitor_diagnostic_setting = {
    diag-mms-github = {
      target_resource_id = module.key_vault.key_vault["kv-mms-github"].id
    }
  }

  monitor_activity_log_alert = {
    ala-mms-github = {
      resource_group_name = "rg-mms-github"
      scopes              = [data.azurerm_subscription.current.id]
      criteria = {
        category = "Recommendation"
      }
    }
  }

  monitor_scheduled_query_rules_alert = {
    sqra-mms-github = {
      resource_group_name = "rg-mms-github"
      location            = "westeurope"
      data_source_id      = module.log_analytics_workspace.log_analytics_workspace["law-mms-github"].id
      query               = "Perf | where ObjectName == \"Processor\" and CounterName == \"% Processor Time\" | summarize AggregatedValue = avg(CounterValue) by bin(TimeGenerated, 5m), Computer"
      trigger = {
        operator  = "GreaterThan"
        threshold = 3
      }
      action = {
        action_group = []
      }
    }
  }
}
