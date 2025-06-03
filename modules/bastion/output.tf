output "bastion_instance" {
  description = "踏み台サーバーとして使うインスタンスの情報"
  value       = aws_instance.this
}

output "bastion_iam_role_session_manager" {
  description = "踏み台サーバーとして使うインスタンスにセッションマネージャーで接続するためのIAMロール"
  value       = aws_iam_role.session_manager
}

output "bastion_iam_instance_profile" {
  description = "踏み台サーバーとして使うインスタンスに付与するインスタンスプロファイル"
  value       = aws_iam_instance_profile.session_manager
}

output "bastion_iam_role_schedule" {
  description = "踏み台サーバーを起動・停止するEventBridge Schedulerに付与するIAMロール"
  value       = aws_iam_role.ec2_schedule
}

output "bastion_iam_role_policy_schedule" {
  description = "踏み台サーバーを起動・停止するEventBridge Schedulerに付与するIAMロールで使うポリシー"
  value       = aws_iam_policy.ec2_schedule
}

output "backup_iam_role" {
  description = "踏み台サーバーのバックアップ用IAMロール"
  value       = aws_iam_role.backup
}

output "backup_iam_policy" {
  description = "踏み台サーバーのバックアップ用IAMポリシー"
  value       = aws_iam_policy.backup.name
}

output "bastion_schedule_start" {
  description = "踏み台サーバーを起動するEventBridge Scheduler"
  value       = aws_scheduler_schedule.bastion_start
}

output "bastion_schedule_stop" {
  description = "踏み台サーバーを停止するEventBridge Scheduler"
  value       = aws_scheduler_schedule.bastion_stop
}

output "bastion_instance_sg" {
  description = "踏み台サーバーとして使うインスタンスに付与するセキュリティグループ"
  value       = aws_security_group.ec2
}

output "backup_plan" {
  description = "踏み台サーバーのバックアップ要件の定義"
  value       = aws_backup_plan.this
}

output "backup_vault" {
  description = "踏み台サーバーのバックアップの保管先"
  value       = aws_backup_vault.this
}

output "backup_selection" {
  description = "バックアップするサーバーの指定"
  value       = aws_backup_selection.this
}