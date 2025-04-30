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

1. 以下のコマンドを実行してください。なお、後ろにコメントアウトで説明がある変数は自分で設定する必要があります。コメントの内容に従ってください。また、tfファイルの`set.tf`のファイル名は任意です。
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

2. 以下コマンドを実行してください。
```
terraform init
terraform plan #ここで、作成されるリソースが正しいか確認してください。
terraform apply #リソースを作成していいかの確認があるので、その時にyesと入力してください。
```
3. 最後に、`Apply complete`と表示されたら完了です。  
ここで、CloudShellは終了しないでください。

### CloudShellからtfstateをダウンロードする
CloudShellのボリュームは一時的なものを使っています。  
そのため、CloudShellでリソースを作成した場合、そのtfstateファイルが消えてしまい`terraform destroy`でリソース削除ができなくなってしまいます。  
以下は、CloudShellからファイルをダウンロードする方法を記述します。

1. 以下コマンドを実行し、tfstateがあるディレクトリまでのパスと、tfstateとtfファイル名を確認してください。
```
pwd
ls
```

2. 右上の"アクション"より"ファイルのダウンロード"を選択します。  
そこに書かれている通り、ダウンロードするtfstateとtfファイルまでのパスを入力し、ローカル端末にダウンロードします。  

このファイルは踏み台サーバーを削除するために使うため、任意の場所に保管してください。

## VSCodeでセッションマネージャーを使う手順
### VScodeインストール
1. ローカル端末にVScodeをインストールします。Qiitaの[この記事](https://qiita.com/GAI-313/items/f3d4722ebeda5ea195d1)を参考にしてインストールしてください。
2. VScodeを開き、画面左の"拡張機能"(四角が4つのアイコン)を選択してください。
3. 左上の検索欄より、"Remote - SSH"、"Remote - SSH: Editing Configuration Files"、"Remote Explorer"と検索し、それぞれをインストールします。

### 補足
- VScodeを使いAWS EC2インスタンスにリモート接続を行うまでは以上の手順で十分ですが、Terraformの開発環境を整える場合は、"拡張機能"より"HashiCorp Terraform"をインストールするとより便利に使えます。
- 拡張機能のインストールに失敗した場合、[Visual Studio Marketplace](https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs)よりインストールファイルを手動でダウンロードすることでインストールすることもできます。

### SSHキーの作成・EC2への登録
1. コマンドプロンプトを開き、`ssh-keygen -t rsa -b 2048 -f {.sshまでのパス}\{公開鍵・秘密鍵の名前}`を入力し、両キーを作成します。以下は出力例です。
```
>ssh-keygen -t rsa -b 2048 -f "C:\Users\your_ussername\.ssh\test"
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in C:\Users\your_ussername\.ssh\test
Your public key has been saved in C:\Users\your_ussername\.ssh\test.pub
The key fingerprint is:
SHA256:eoDzB~~~/6LY tisnt\your_ussername@S2212C13070-T1
The key's randomart image is:
+---[RSA 2048]----+
|..+= o+=         |
| .. o.* o .      |
|.o *o*o. * .     |
|+.+ XB..= o      |
| oo.+o*oS+       |
|   = B.o. .      |
|  . + o .E       |
|       .         |
|                 |
+----[SHA256]-----+
```

1. セッションマネージャーで接続先EC2 インスタンスに繋ぎます。
2. `sudo su {使いたいユーザー}`で接続先で使うユーザーに切り替えます。なお、本手順ではEC2のデフォルトユーザーである`ec2-user`を使います。
3. `~/.ssh/authorized_keys`に先ほど作成した公開鍵の中身を入力し、権限を変更してください。以下は2.～3.の手順の例です。
```
sh-5.2$ sudo su ec2-user
[ec2-user@ip-10-0-11-43 bin]$ vi ~/.ssh/authorized_keys
[ec2-user@ip-10-0-11-43 bin]$ cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1~~~d6s6waL
[ec2-user@ip-10-0-11-43 .ssh]$ chmod 700 ~/.ssh/authorized_keys
```

### VScodeで接続
1. ローカル端末に戻り、`{.sshまでのパス}\config`に以下の内容を入力してください。なお、以下の`ProxyCommand`の項目は、プロキシを回避するための設定なので、端末にプロキシ設定をしていない場合は不要です。
```
Host {接続するときの任意のホスト名}
    HostName {接続先EC2 インスタンスのインスタンスID}
    IdentityFile {.sshまでのパス}\{秘密鍵の名前}
    User {接続先で使うユーザー名}
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --no-verify
```

以下は設定例です。
```
Host test
    HostName i-02e3aaaaaaaaaaaa9
    IdentityFile C:\Users\your_ussername\.ssh\test
    User ec2-user
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession --no-verify
```

2. 画面左下の"リモートウィンドウを開きます"(><のようなマーク)を選択し、画面上の"ホストに接続する"を選択します。
3. 1.で設定した、任意のホスト名を選択します。
4. 接続先で使うOS名を聞かれるので、"Linux"を選択します。その後、初めてリモート接続する際は、接続するホストのフィンガープリントを追加するかの確認が行われるので、"続行"を選択します。
5. 新しくVScodeのウィンドウが開き、以下のように左下の><マークに接続先のホスト名が書かれていれば接続成功です。

## 踏み台サーバーリソースの削除
ここでは作成した踏み台サーバーを削除する方法を説明します。  

1. CloudShellを起動します。  
2. 右上の"アクション"より"ファイルのアップロード"を選択し、手順"CloudShellからtfstateをダウンロードする"でダウンロードしたファイルをアップロードしてください。  
3. その後、以下コマンドで踏み台サーバーを削除してください。
```
terraform init
terraform destroy
```