## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.96.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.backup_backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.backup_restore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.backup_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ec2_schedule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_scheduler_schedule.bastion_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.bastion_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_security_group.ec2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_policy.session_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_eip"></a> [assign\_eip](#input\_assign\_eip) | EC2にEIPを割り当てるかどうか | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | サブネットのアベイラビリティゾーン | `string` | `"ap-northeast-1a"` | no |
| <a name="input_custom_userdata"></a> [custom\_userdata](#input\_custom\_userdata) | カスタムのユーザーデータのパス（未指定の場合はデフォルトのユーザーデータを使用） | `string` | `""` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | 終了保護を有効にするかどうか | `bool` | `true` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | バックアップの世代数 | `number` | n/a | yes |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | 踏み台サーバーで使うインスタンスタイプ | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | VPCのリージョン | `string` | `"ap-northeast-1"` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | 各種リソースに付ける共通の名前 | `string` | n/a | yes |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | 踏み台サーバーを起動する時間 | `string` | n/a | yes |
| <a name="input_stop_time"></a> [stop\_time](#input\_stop\_time) | 踏み台サーバーを停止する時間 | `string` | n/a | yes |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | サブネットのCIDRブロック | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | 踏み台サーバーを配置するサブネットのID（未指定の場合は自動生成） | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPCのCIDRブロック | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | 踏み台サーバーを配置するVPCのID（未指定の場合は自動生成） | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_iam_policy"></a> [backup\_iam\_policy](#output\_backup\_iam\_policy) | 踏み台サーバーのバックアップ用IAMポリシー |
| <a name="output_backup_iam_role"></a> [backup\_iam\_role](#output\_backup\_iam\_role) | 踏み台サーバーのバックアップ用IAMロール |
| <a name="output_backup_plan"></a> [backup\_plan](#output\_backup\_plan) | 踏み台サーバーのバックアップ要件の定義 |
| <a name="output_backup_selection"></a> [backup\_selection](#output\_backup\_selection) | バックアップするサーバーの指定 |
| <a name="output_backup_vault"></a> [backup\_vault](#output\_backup\_vault) | 踏み台サーバーのバックアップの保管先 |
| <a name="output_bastion_iam_instance_profile"></a> [bastion\_iam\_instance\_profile](#output\_bastion\_iam\_instance\_profile) | 踏み台サーバーとして使うインスタンスに付与するインスタンスプロファイル |
| <a name="output_bastion_iam_role_policy_schedule"></a> [bastion\_iam\_role\_policy\_schedule](#output\_bastion\_iam\_role\_policy\_schedule) | 踏み台サーバーを起動・停止するEventBridge Schedulerに付与するIAMロールで使うポリシー |
| <a name="output_bastion_iam_role_schedule"></a> [bastion\_iam\_role\_schedule](#output\_bastion\_iam\_role\_schedule) | 踏み台サーバーを起動・停止するEventBridge Schedulerに付与するIAMロール |
| <a name="output_bastion_iam_role_session_manager"></a> [bastion\_iam\_role\_session\_manager](#output\_bastion\_iam\_role\_session\_manager) | 踏み台サーバーとして使うインスタンスにセッションマネージャーで接続するためのIAMロール |
| <a name="output_bastion_instance"></a> [bastion\_instance](#output\_bastion\_instance) | 踏み台サーバーとして使うインスタンスの情報 |
| <a name="output_bastion_instance_sg"></a> [bastion\_instance\_sg](#output\_bastion\_instance\_sg) | 踏み台サーバーとして使うインスタンスに付与するセキュリティグループ |
| <a name="output_bastion_schedule_start"></a> [bastion\_schedule\_start](#output\_bastion\_schedule\_start) | 踏み台サーバーを起動するEventBridge Scheduler |
| <a name="output_bastion_schedule_stop"></a> [bastion\_schedule\_stop](#output\_bastion\_schedule\_stop) | 踏み台サーバーを停止するEventBridge Scheduler |