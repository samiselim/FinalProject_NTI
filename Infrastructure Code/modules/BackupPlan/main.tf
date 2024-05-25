resource "aws_iam_role" "aws_backup_role" {
  name = "AWSBackupDefaultServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "backup.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.aws_backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}


resource "aws_backup_vault" "default_vault" {
  name = "Default"
}
resource "aws_backup_plan" "daily_plan" {
  name = "jenkins_backup"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.default_vault.name
    schedule          = "cron(0 5 * * ? *)"

    lifecycle {
      delete_after = 30
    }
  }
}
resource "aws_backup_selection" "backup_selection" {
  iam_role_arn = aws_iam_role.aws_backup_role.arn
  name         = "EC2Selection"
  plan_id      = aws_backup_plan.daily_plan.id

  resources = [
    var.ec2_arn,
  ]
}