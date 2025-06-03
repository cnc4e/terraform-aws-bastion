resource "aws_backup_plan" "this" {
  name = var.resouce_name

  rule {
    rule_name         = var.resouce_name
    target_vault_name = aws_backup_vault.this.name
    schedule          = "cron(0 15 ? * MON-FRI *)"

    lifecycle {
      delete_after = 10
    }
  }
}

resource "aws_backup_vault" "this" {
  name = var.resouce_name
}


resource "aws_backup_selection" "this" {
  name         = var.resouce_name
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.this.id

  resources = [
    aws_instance.this.arn
  ]
}
