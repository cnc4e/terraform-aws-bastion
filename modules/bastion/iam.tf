# Session Manager

resource "aws_iam_role" "session_manager" {
  name               = "${var.resouce_name}-session-manager"
  assume_role_policy = file("${path.module}/policy/session_manager_policy.json")
}

data "aws_iam_policy" "session_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.session_manager.name
  policy_arn = data.aws_iam_policy.session_manager.arn
}

resource "aws_iam_instance_profile" "session_manager" {
  name = "${var.resouce_name}-session-manager-profile"
  role = aws_iam_role.session_manager.name
}

# Schedule for bastion server

resource "aws_iam_role" "ec2_schedule" {
  name               = "${var.resouce_name}-bastion-schedule"
  assume_role_policy = file("${path.module}/policy/ec2_schedule.json")
}

resource "aws_iam_policy" "ec2_schedule" {
  name   = "${var.resouce_name}-bastion-schedule"
  policy = file("${path.module}/policy/ec2_schedule_policy.json")
}

resource "aws_iam_role_policy_attachment" "ec2_schedule" {
  role       = aws_iam_role.ec2_schedule.name
  policy_arn = aws_iam_policy.ec2_schedule.arn
}

# backup
resource "aws_iam_role" "backup" {
  name               = "${var.resouce_name}-bastion-backup"
  assume_role_policy = file("${path.module}/policy/backup_assum_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "backup_backup" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_iam_role_policy_attachment" "backup_restore" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

resource "aws_iam_policy" "backup" {
  name = "${var.resouce_name}-backup-policy"

  policy = templatefile(
    "${path.module}/policy/backup_policy.json",
    {
      bastion_instance_iam = aws_iam_role.session_manager.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "backup_role" {
  role       = aws_iam_role.backup.name
  policy_arn = aws_iam_policy.backup.arn
}