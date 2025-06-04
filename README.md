## Usages
実行手順は[このドキュメント](https://github.com/cnc4e/terraform-aws-bastion/blob/main/docs/usage.md)を参考にしてください。

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.58.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/bastion | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | 踏み台サーバーで使うインスタンスタイプ | `string` | `"t2.medium"` | no |
| <a name="input_resouce_name"></a> [resouce\_name](#input\_resouce\_name) | 各種リソースに付ける共通の名前 | `string` | n/a | yes |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | 踏み台サーバーを起動する時間 | `string` | `"cron(55 8 * * ? *)"` | no |
| <a name="input_stop_time"></a> [stop\_time](#input\_stop\_time) | 踏み台サーバーを停止する時間 | `string` | `"cron(0 19 * * ? *)"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | 踏み台サーバーを配置するサブネットのID | `string` | n/a | yes |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | 踏み台サーバーを起動・停止する時間のタイムゾーン | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | 踏み台サーバーを配置するVPCのID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion"></a> [bastion](#output\_bastion) | Bastion module |

## 機能説明

### バックアップについて
踏み台サーバーのバックアップ方法としてAWS Backupを使っています。
バックアップは平日の0時に自動実行されます。
世代数はデフォルトでは10ですが、`generation`変数を指定することで変更が可能です。
バックアップよりサーバーをリストアした場合、そのバックアップ時のインスタンスが新規で作られます。
そのため、**インスタンスをリストアした後に、そのリソースをtfstateファイルに認識させる必要がある**ことに注意してください。

AWS Backupからサーバーをリストアする手順は[このドキュメント](https://github.com/cnc4e/terraform-aws-bastion/blob/main/docs/backup.md)を参考にしてください。
