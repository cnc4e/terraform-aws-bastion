# Session Manager

resource "aws_iam_role" "session_manager" {
  name               = "${var.resource_name}-session-manager"
  assume_role_policy = file("${path.module}/policy/session_manager_policy.json")

  tags = {
    Name = "${var.resource_name}-session-manager-role"
  }
}

data "aws_iam_policy" "session_manager" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "session_manager" {
  role       = aws_iam_role.session_manager.name
  policy_arn = data.aws_iam_policy.session_manager.arn
}

resource "aws_iam_instance_profile" "session_manager" {
  name = "${var.resource_name}-session-manager-profile"
  role = aws_iam_role.session_manager.name
  tags = {
    Name = "${var.resource_name}-session-manager-profile"
  }
}

# Schedule for bastion server

resource "aws_iam_role" "ec2_schedule" {
  name               = "${var.resource_name}-bastion-schedule"
  assume_role_policy = file("${path.module}/policy/ec2_schedule.json")
  tags = {
    Name = "${var.resource_name}-bastion-schedule-role"
  }
}

resource "aws_iam_policy" "ec2_schedule" {
  name   = "${var.resource_name}-bastion-schedule"
  policy = file("${path.module}/policy/ec2_schedule_policy.json")
  tags = {
    Name = "${var.resource_name}-bastion-schedule-policy"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_schedule" {
  role       = aws_iam_role.ec2_schedule.name
  policy_arn = aws_iam_policy.ec2_schedule.arn
}

# backup
resource "aws_iam_role" "backup" {
  name               = "${var.resource_name}-bastion-backup"
  assume_role_policy = file("${path.module}/policy/backup_assume_role_policy.json")
  tags = {
    Name = "${var.resource_name}-bastion-backup-role"
  }
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
  name = "${var.resource_name}-backup-policy"

  policy = templatefile(
    "${path.module}/policy/backup_policy.json",
    {
      bastion_instance_iam = aws_iam_role.session_manager.arn
    }
  )
  tags = {
    Name = "${var.resource_name}-backup-policy"
  }
}

resource "aws_iam_role_policy_attachment" "backup_role" {
  role       = aws_iam_role.backup.name
  policy_arn = aws_iam_policy.backup.arn
}