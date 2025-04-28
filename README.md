## 実行手順
AWSのCloudShellを起動し、以下のコマンドを入力してTerraformをインストールしてください。このときリージョンがリソースを作りたい場所に指定されていることを確認してください。
```
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```
`terraform version`を実行し、バージョンが表示されることを確認してください。

次に、以下のコマンドを実行してください。なお、後ろにコメントアウトで説明がある変数は自分で設定する必要があります。コメントの内容に従ってください。
```
cat <<EOF > set.tf
module "bastion" {
  source  = "cnc4e/bastion/aws"
  version = "0.1.0" #使うバージョンの指定。基本的にはlatestとなっているバージョンを記述してください。
  # insert the 4 required variables here(defaultで決めていない変数は以下のように自分で記述しないとエラーになります)
  resouce_name = "sample" #各種リソースに付ける名前
  subnet_id = "subnet-aaa" #サーバーを配置するサブネットのID。
  timezone = "Asia/Tokyo" #サーバーを自動停止・開始する時刻のタイムゾーン。
  vpc_id = "vpc-aaa" #サーバーを配置するVPCのID。
}
EOF
```

`terraform init`コマンドを実行した後に`terraform plan`コマンドを実行し、作成されるリソースが正しいか確認してください。問題なければ`terraform apply`を実行し、確認時に`yes`と入力してください。
最後に、`Apply complete`と表示されたら完了です。

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
