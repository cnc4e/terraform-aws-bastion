output "bastion_instance" {
  description = "Bastion instance"
  value       = aws_instance.this
}

output "bastion_iam_role_session_manager" {
  description = "Bastion instance IAM role for session manager"
  value       = aws_iam_role.session_manager
}

output "bastion_iam_instance_profile" {
  description = "Bastion instance IAM instance profile"
  value       = aws_iam_instance_profile.session_manager
}

output "bastion_iam_role_schedule" {
  description = "Bastion instance IAM role for schedule"
  value       = aws_iam_role.ec2_schedule
}

output "bastion_iam_role_policy_schedule" {
  description = "Bastion instance IAM role policy for schedule"
  value       = aws_iam_policy.ec2_schedule
}

output "bastion_schedule_start" {
  description = "Bastion schedule start"
  value       = aws_scheduler_schedule.bastion_start
}

output "bastion_schedule_stop" {
  description = "Bastion schedule stop"
  value       = aws_scheduler_schedule.bastion_stop
}

output "bastion_instance_sg" {
  description = "Bastion instance security group"
  value       = aws_security_group.ec2
}