## 実行手順
### CloudShell起動
AWSマネージドコンソールにログインし、画面下の`CloudShell`よりCloudShell起動してください。このときリージョンがリソースを作りたい場所に指定されていることを確認してください。

### Terraformインストール
以下のコマンドを入力してTerraformをインストールしてください。
```
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```
インストール後に`terraform version`コマンドを実行し、バージョンが表示されることを確認してください。

### 踏み台サーバー作成

1. 以下のコマンドを実行してください。  
なお、後ろにコメントアウトで説明がある変数は自分で設定する必要があります。コメントの内容に従ってください。  
また、tfファイルの`set.tf`のファイル名は任意です。
```
cat <<EOF > set.tf
module "bastion" {
  source       = "cnc4e/bastion/aws"
  version      = "0.1.0" #使うバージョンの指定。基本的にはlatestとなっているバージョンを記述してください。

  # insert the 3 required variables here(defaultで決めていない変数は以下のように自分で記述しないとエラーになります)
  resouce_name = "sample" #各種リソースに付ける名前
  subnet_id    = "subnet-aaa" #サーバーを配置するサブネットのID。
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
そのため、CloudShellでリソースを作成した場合、tfstateファイルが消えてしまい`terraform destroy`でリソース削除ができなくなってしまいます。  
以下は、CloudShellからファイルをダウンロードする方法を記述します。

1. 以下コマンドを実行し、tfstateがあるディレクトリまでのパスと、tfstateとtfファイル名を確認してください。
```
pwd
ls
```

2. 右上の"アクション"より"ファイルのダウンロード"を選択します。  
そこに書かれている通り、ダウンロードするtfstateとtfファイルまでのパスを入力し、ローカル端末にダウンロードします。  

このファイルは踏み台サーバーを削除するために使うため、**任意の場所に保管してください**。

## VSCodeでセッションマネージャーを使う手順
### aws cliのインストール
VSCodeでセッションマネージャーを使うには、`aws cli`コマンドで接続先EC2インスタンスのあるアカウントにアクセスできる環境が必要です。[aws cliに関するAWS公式ドキュメント](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html)に従って**ローカル端末に**aws cliをインストールしてください。  
ドキュメントにも書かれていますが、インストール後に`aws --version`コマンドを実行し、バージョンが表示されることを確認してください。

### aws configureの設定
aws cliをインストールしただけではアカウントへアクセスすることはできず、aws configureを設定する必要があります。**ローカル端末に**aws configureを設定してください。以下は設定の手順です。
1. AWSコンソールにログインし、"IAM > ユーザー > {使うIAMユーザー}"に移動します。  
2. "許可"欄の"許可ポリシー"より、使うIAMユーザーに"AmazonSSMFullAccess"と"EC2インスタンスへのアクセス権限"のポリシーが付与されていることを確認してください。
3. "セキュリティ認証情報"欄の"アクセスキー"を選択します。
4. ユースケースに"コマンドラインインターフェイス (CLI)"を選択し、アクセスキーを作成し、これを保存します。このとき、アクセスキーとシークレットキーの2つが作成されますが、このうち**シークレットキーは作成したタイミングでしか表示されないことに注意してください**。
5. **ローカル端末に戻り**`aws configure`コマンドを実行し、以下のように入力してください。  
なお、この時同時にAWSプロファイルが設定されます。このプロファイル名を指定する時は`aws configure --profile {プロファイル名}`で設定してください。何も指定しないときは`default`という名前でプロファイルが作成されます。
```
C:\Users\USERNAME> aws configure
AWS Access Key ID [None]: AKIAAAAAAAAAAAAAAMPLE #先ほど作成したアクセスキー
AWS Secret Access Key [None]: wJalrXUtnFEMAAAAAAAAAAAAAKEY #先ほど作成したシークレットキー
Default region name [None]: ap-northeast-1 #このプロファイルでアクセスするリージョンのデフォルト設定
Default output format [None]: json #CLIコマンドが返す出力のデフォルト形式
```
6. `aws ec2 describe-instances`コマンドを実行し、EC2の一覧が表示されることを確認してください。

### SessionManagerPluginのインストール
SessionManagerPluginをインストールすることで、ローカル端末からセッションマネージャーの開始と終了の操作が行えるようになります。[SessionManagerPluginに関するAWS公式ドキュメント](https://docs.aws.amazon.com/ja_jp/systems-manager/latest/userguide/install-plugin-windows.html)に従って**ローカル端末に**SessionManagerPluginをインストールしてください。  
ドキュメントにも書かれていますが、インストール後に`session-manager-plugin`コマンドを実行し、以下のようにインストールに成功している旨の文章が返ってくることを確認してください。
```
C:\Users\USERNANE> session-manager-plugin
The Session Manager plugin is installed successfully. Use the AWS CLI to start a session.
```

### VSCodeインストール
1. ローカル端末にVSCodeをインストールします。Qiitaの[この記事](https://qiita.com/GAI-313/items/f3d4722ebeda5ea195d1)を参考にしてインストールしてください。
2. VSCodeを開き、画面左の"拡張機能"(四角が4つのアイコン)を選択してください。
3. 左上の検索欄より、"Remote - SSH"、"Remote - SSH: Editing Configuration Files"、"Remote Explorer"と検索し、それぞれをインストールします。

#### 補足1 VSCodeの拡張機能のインストール
VSCodeを使いAWS EC2インスタンスにリモート接続を行うまでは以上の手順で十分ですが、Terraformの開発環境を整える場合は、"拡張機能"より"HashiCorp Terraform"をインストールするとより便利に使えます。

#### 補足2 拡張機能インストールに失敗した時の対応
拡張機能のインストールに失敗した場合、[Visual Studio Marketplace](https://marketplace.visualstudio.com/search?target=VSCode&category=All%20categories&sortBy=Installs)よりインストールファイルを手動でダウンロードすることでインストールすることもできます。

#### 補足3 プロキシ環境下でのVSCodeの設定
VSCodeを使う端末がプロキシ環境下の場合、VSCodeにプロキシを設定する必要があります。以下の手順で設定を行ってください。
1. VSCodeを開き、左下の歯車マークの"管理"より"設定"を選択してください。
2. "アプリケーション > プロキシ"に移動します。
3. "プロキシ"欄の"Http: Proxy"に端末に設定しているプロキシを入力して保存してください。

### SSHキーの作成・EC2への登録
1. **ローカル端末で**コマンドプロンプトを開き、`ssh-keygen -t rsa -b 2048 -f {.sshまでのパス}\{公開鍵・秘密鍵の名前}`を入力し、両キーを作成します。以下は出力例です。  
なお、ここの`Enter passphrase`ではパスフレーズを設定できます。これを設定することで、キーを使う際にパスフレーズの入力が必要となり、キー流出に対するセキュリティリスクを解消できます。  
ここで空白のままEnterキーを押すことで、パスフレーズを設定しないこともできます。  
`Enter same passphrase again`ではパスフレーズを再入力するものですので、パスフレーズを設定した時は再入力し、設定していない時は空白のままEnterキーを押してください。
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

2. **AWSコンソールの**セッションマネージャーで接続先EC2 インスタンスに繋ぎます。
3. `sudo su {使いたいユーザー}`で接続先で使うユーザーに切り替えます。なお、本手順ではEC2のデフォルトユーザーである`ec2-user`を使います。
4. `~/.ssh/authorized_keys`に先ほど作成した公開キーの中身を入力し、権限を変更してください。  
なお、この公開キーは1.の手順で作成したキーのうち、`.pub`とつくファイルです。  
以下は2.～3.の手順の例です。
```
sh-5.2$ sudo su ec2-user
[ec2-user@ip-10-0-11-43 bin]$ vi ~/.ssh/authorized_keys
[ec2-user@ip-10-0-11-43 bin]$ cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1~~~d6s6waL
[ec2-user@ip-10-0-11-43 .ssh]$ chmod 700 ~/.ssh/authorized_keys
```

### VSCodeで接続
1. ローカル端末に戻り、`{.sshまでのパス}\config`に以下の内容を入力してください。
```
Host {接続するときの任意のホスト名}
    HostName {接続先EC2 インスタンスのインスタンスID}
    IdentityFile {.sshまでのパス}\{秘密鍵の名前}
    User {接続先で使うユーザー名}
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession
```

以下は設定例です。
```
Host test
    HostName i-02e3aaaaaaaaaaaa9
    IdentityFile C:\Users\your_ussername\.ssh\test
    User ec2-user
    ProxyCommand aws ssm start-session --target %h --document-name AWS-StartSSHSession
```

2. VSCodeを開き、画面左下の"リモートウィンドウを開きます"(><のようなマーク)を選択し、画面上の"ホストに接続する"を選択します。
3. 1.で設定した、任意のホスト名を選択します。
4. 接続先で使うOS名を聞かれるので、"Linux"を選択します。その後、初めてリモート接続する際は、接続するホストのフィンガープリントを追加するかの確認が行われるので、"続行"を選択します。
5. 新しくVSCodeのウィンドウが開き、左下の><マークに接続先のホスト名が書かれていれば接続成功です。

#### 補足1 プロキシ環境下でアクセス時にSSLエラーが出力される時の対応
プロキシ環境下でVSCodeからアクセスした際、端末およびVSCodeにプロキシを設定しているにも関わらずSSLエラーにより接続できないことがあります。  
この場合、aws cliがプロキシの独自証明書を認識していない可能性があります。対応として、aws cliのconfigファイルに証明書を直接認識させてください。以下はその手順です。  
1. 任意の場所にプロキシの証明書を配置します。証明書が複数個ある場合は、新しく`.crt`ファイルを1つ作り、そこに証明書の中身を全てコピペしてください。
2. aws cliのconfigファイルを開き、以下のように使うプロファイルに`ca_bundle`変数に証明書までのパスを入力し、保存してください。  
  なお、aws cliのconfigファイルは、デフォルトでは`C:\Users\{your_username}\.aws\config`に配置されます。
```
[profile test]
region = ap-northeast-1
output = json
ca_bundle = C:\Users\{your_username}\.ssh\test.crt
```

## 踏み台サーバーリソースの削除
ここでは作成した踏み台サーバーを削除する方法を説明します。  

1. CloudShellを起動します。  
2. 右上の"アクション"より"ファイルのアップロード"を選択し、手順[CloudShellからtfstateをダウンロードする](#cloudshellからtfstateをダウンロードする)でダウンロードしたファイルをアップロードしてください。  
3. その後、以下コマンドで踏み台サーバーを削除してください。
```
terraform init
terraform destroy
```