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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_eip"></a> [assign\_eip](#input\_assign\_eip) | EC2にEIPを割り当てるかどうか | `bool` | `false` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | サブネットのアベイラビリティゾーン | `string` | `"ap-northeast-1a"` | no |
| <a name="input_custom_userdata"></a> [custom\_userdata](#input\_custom\_userdata) | カスタムのユーザーデータのパス（未指定の場合はデフォルトのユーザーデータを使用） | `string` | `""` | no |
| <a name="input_disable_api_termination"></a> [disable\_api\_termination](#input\_disable\_api\_termination) | 終了保護を有効にするかどうか | `bool` | `true` | no |
| <a name="input_generation"></a> [generation](#input\_generation) | バックアップの世代数 | `number` | `10` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | 踏み台サーバーで使うインスタンスタイプ | `string` | `"t2.medium"` | no |
| <a name="input_region"></a> [region](#input\_region) | VPCのリージョン | `string` | `"ap-northeast-1"` | no |
| <a name="input_resource_name"></a> [resource\_name](#input\_resource\_name) | 各種リソースに付ける共通の名前 | `string` | n/a | yes |
| <a name="input_start_time"></a> [start\_time](#input\_start\_time) | 踏み台サーバーを起動する時間 | `string` | `"cron(55 8 ? * MON-FRI *)"` | no |
| <a name="input_stop_time"></a> [stop\_time](#input\_stop\_time) | 踏み台サーバーを停止する時間 | `string` | `"cron(0 19 ? * MON-FRI *)"` | no |
| <a name="input_subnet_cidr"></a> [subnet\_cidr](#input\_subnet\_cidr) | サブネットのCIDRブロック | `string` | `"10.0.1.0/24"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | 踏み台サーバーを配置するサブネットのID（未指定の場合は自動生成） | `string` | `""` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPCのCIDRブロック | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | 踏み台サーバーを配置するVPCのID（未指定の場合は自動生成） | `string` | `""` | no |

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

### 踏み台サーバーを終了する方法
安全性の観点から、踏み台サーバーには終了保護がデフォルトで有効になっています。サーバーを終了させるには、終了保護を無効化する必要があります。
1. AWSマネジメントコンソールにログインし、「EC2」サービスを選択します。
2. 「インスタンス」一覧から、終了したいインスタンスを選択します。
3. 「アクション」>「インスタンスの設定」>「終了保護の設定」を選択します。
4. 「終了保護」のチェックを外し、「保存」ボタンを押下します。
5. EC2インスタンスを終了させます。

終了保護は、AWSマネジメントコンソールやAWS CLIでの終了操作をブロックしますが、Terraform destroyでは終了保護が有効でもインスタンスが削除されてしまう場合があります。Terraformによる操作を行う場合は、終了保護の有無に関わらず、インスタンスが削除される可能性があることに十分注意してください。

### 任意のuserdataを指定する方法
任意のuserdataを設定したい場合、以下の例のように、`custom_userdata`変数に「カスタムのuserdataファイルのパス」を渡します。
```
custom_userdata = "./modules/bastion/script/custom_userdata.sh"
```

なお、`custom_userdata`変数が未指定の場合は、事前に用意されたデフォルトのuserdata.shが適用されます。

また、カスタムのuserdataを適用させる際、スクリプトに「SSMエージェントをインストールする」コマンドを含めるようにしてください。
```
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
```

### VPC・サブネット・リージョン・AZの指定方法と注意点
#### VPCとサブネットのID指定について
vpc_idのみ指定、subnet_id未指定
→指定した既存VPC上に新規サブネットが作成されます。
vpc_id未指定、subnet_idのみ指定
→エラーが発生します。サブネットは必ずVPCに所属しているため、このパターンは利用できません。
vpc_id・subnet_id両方未指定
→新規VPCおよび新規サブネットが作成されます。
vpc_id・subnet_id両方指定
→既存VPC・既存サブネットが利用されます。
注意:
新規サブネット作成時、subnet_cidrの値が既存サブネットと重複している場合、エラーとなります。重複しないCIDRを必ず指定してください。

#### リージョンとアベイラビリティゾーン（AZ）指定について
regionとavailability_zoneは両方指定するか、両方未指定にしてください。
片方のみ指定した場合や、リージョン・AZの組み合わせに不整合がある場合はエラーとなります。
両方未指定の場合は、デフォルトで ap-northeast-1（リージョン）、ap-northeast-1a（AZ）が適用されます。
VPCやサブネットのIDを指定する場合は、それらが一致したリージョン・AZに存在している必要があります。