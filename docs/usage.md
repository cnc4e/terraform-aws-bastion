## 実行手順
### CloudShell起動
AWSマネージドコンソールに入り、画面下の`CloudShell`よりをCloudShell起動してください。このときリージョンがリソースを作りたい場所に指定されていることを確認してください。

### Terraformインストール
以下のコマンドを入力してTerraformをインストールしてください。
```
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```
`terraform version`を実行し、バージョンが表示されることを確認してください。

### 踏み台サーバー作成

次に、以下のコマンドを実行してください。なお、後ろにコメントアウトで説明がある変数は自分で設定する必要があります。コメントの内容に従ってください。
```
cat <<EOF > set.tf
module "bastion" {
  source       = "cnc4e/bastion/aws"
  version      = "0.1.0" #使うバージョンの指定。基本的にはlatestとなっているバージョンを記述してください。

  # insert the 4 required variables here(defaultで決めていない変数は以下のように自分で記述しないとエラーになります)
  resouce_name = "sample" #各種リソースに付ける名前
  subnet_id    = "subnet-aaa" #サーバーを配置するサブネットのID。
  timezone     = "Asia/Tokyo" #サーバーを自動停止・開始する時刻のタイムゾーン。
  vpc_id       = "vpc-aaa" #サーバーを配置するVPCのID。
}
EOF
```

以下コマンドを実行してください。
```
terraform init
terraform plan #ここで、作成されるリソースが正しいか確認してください。
terraform apply #リソースを作成していいかの確認があるので、その時にyesと入力してください。
```
最後に、`Apply complete`と表示されたら完了です。