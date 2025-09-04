resource "aws_backup_plan" "this" {
  count = var.enable_backup ? 1 : 0
  name  = var.resource_name

  rule {
    rule_name         = var.resource_name
    target_vault_name = aws_backup_vault.this[0].name
    schedule          = "cron(0 15 ? * MON-FRI *)"

    lifecycle {
      delete_after = var.generation
    }
  }
}

resource "aws_backup_vault" "this" {
  count = var.enable_backup ? 1 : 0
  name  = var.resource_name
}


resource "aws_backup_selection" "this" {
  count        = var.enable_backup ? 1 : 0
  name         = var.resource_name
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.this[0].id

  resources = [
    aws_instance.this.arn
  ]
}
