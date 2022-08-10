data "okta_group" "databricks_users" {
  name = "TF-SG - Databricks E2 users"
}
data "okta_group" "analytics" {
  name = "Analytics - Analytics"
}
data "okta_group" "merchant_selection" {
  name = "TF-SG - merchant selection"
}

data "okta_group" "revenue_data" {
  name = "TF-SG - revenue_data"
}

module okta_group {
  source      = "../../modules/group_ignore_users"
  name        = "TF-SG - Databricks E2 Root"
  description = "Root Databricks E2 root group"
  # Do not add users directly to this list.
  # Add one-off users to groups/tf_sg_databricks_e2_users/group.tf
  # Add groups to okta_group_rule
  users = []
}
        
resource "okta_group_rule" "tf_sg_databricks_e2_users" {
  name              = "Sync groups to Databricks"
  status            = "ACTIVE"
  group_assignments = [module.okta_group.group_id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "isMemberOfAnyGroup(\"${data.okta_group.databricks_users.id}\",\"${data.okta_group.analytics.id}\",\"${data.okta_group.merchant_selection.id}\",\"${data.okta_group.revenue_data.id}\")"
}

output "group_id" {
  value = module.okta_group.group_id
}
