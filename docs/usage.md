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

次に、以下のコマンドを実行してください。なお、後ろにコメントアウトで説明がある変数は自分で設定する必要があります。コメントの内容に従ってください。また、tfファイルの`set.tf`のファイル名は任意です。
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
ここで、CloudShellは終了しないでください。

### CloudShellからtfstateをダウンロードする
CloudShellのボリュームは一時的なものを使っています。  
そのため、CloudShellでリソースを作成した場合、そのtfstateファイルが消えてしまい`terraform destroy`でリソース削除ができなくなってしまいます。  
以下は、CloudShellからファイルをダウンロードする方法を記述します。

以下コマンドを実行し、tfstateがあるディレクトリまでのパスと、tfstateとtfファイル名を確認してください。
```
pwd
ls
```

右上の"アクション"より"ファイルのダウンロード"を選択します。  
そこに書かれている通り、ダウンロードするtfstateとtfファイルまでのパスを入力し、ローカル端末にダウンロードします。  

このファイルは踏み台サーバーを削除するために使うため、任意の場所に保管してください。

## 踏み台サーバーリソースの削除
ここでは作成した踏み台サーバーを削除する方法を説明します。  

CloudShellを起動します。  
右上の"アクション"より"ファイルのアップロード"を選択し、手順"CloudShellからtfstateをダウンロードする"でダウンロードしたファイルをアップロードしてください。  
その後、以下コマンドで踏み台サーバーを削除してください。
```
terraform init
terraform destroy
```