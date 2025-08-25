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

### 踏み台サーバーの自動開始・停止設定について
踏み台サーバーの自動開始・停止設定としてAmazon EventBridgeを使っています。
デフォルトでは平日の8時55分に開始され、平日の19時に停止します。
タイムゾーンは、デフォルトでは日本時間です。
開始時刻の設定は、bastionモジュールを実行する時に`start_time`変数にcron式を設定することで行います。
例として、平日の8時55分に設定したい時は`start_time=cron(55 8 ? * MON-FRI *)`のようにします。
停止時刻の設定は`stop_time`変数にcron式を設定してください。
なお、ここで各変数に`cron`の文字列を加えないことで、スケジュール設定を行わないこともできます。
例として、以下のように変数を設定した場合、自動開始は設定されますが、自動停止は設定されません。
```
start_time=cron(55 8 ? * MON-FRI *)
stop_time=cr(55 8 ? * MON-FRI *)
```

### 踏み台サーバーのファイルをダウンロードする方法
ファイルをTeams等で連携したいなど、踏み台サーバーにあるデータをローカルにダウンロードしたいことがあると思います。
フォルダをダウンロードする場合はS3 バケットを使う方法があります。
S3 バケットを使う方法は以下の通りです。
1. AWSマネジメントコンソールより"Amazon S3 > 汎用バケット"より汎用バケット欄から"バケットを作成"を押下します。
2. 適切なバケット名を記入し、ページ下の"バケットを作成"を押下します。なお、この1～2手順は既に使えるS3 バケットがある場合は不要です。
3. VS Codeまたはセッションマネージャーより踏み台サーバーに接続し、`aws s3 cp {ダウンロードしたいファイルまでのパス} s3://{コピー先のバケット名}/{コピー先までパス}`のコマンドを実行します。以下はその例です。
```
$ aws s3 cp /home/ssm-user/terraform-aws-bastion/test/backup.md s3://kato-test/test/
upload: test/backup.md to s3://kato-test/test/backup.md      
```
4. AWSマネジメントコンソールよりコピー先のS3バケットまで移動し、ダウンロードしたいファイルにチェックを入れ、画面上の"ダウンロード"を押下します。

### EBSボリュームを拡張する方法
EC2インスタンスのEBSボリューム容量が足りなくなった場合、後から拡張することができます。
1. AWSマネジメントコンソールにログインし、「EC2」サービスを選択します。
2. 左側メニューの「Elastic Block Store」→「ボリューム」をクリックします。
3. 拡張したいEC2インスタンスにアタッチされているボリュームを選択します。
4. 「ボリュームの変更」を選択します。
5. 「サイズ (GiB)」欄で希望の容量を入力し、「変更」をクリックします。
6. 拡張が完了したら、EC2インスタンスにSSH等で接続します。
7. 以下のコマンドで新しいディスクサイズを認識させ、ファイルシステムを拡張します。
```
$ sudo growpart /dev/xvda 1
$ sudo resize2fs /dev/xvda1    
```
8. df -hコマンドなどで、ディスク容量が増えていることを確認します。
