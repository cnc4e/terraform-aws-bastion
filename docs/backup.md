## バックアップを使ったサーバーのリストア方法

1. AWSマネージドコンソールより"AWS Backup > バックアッププラン"より作成した踏み台サーバーと同じ名前のバックアッププランを押下します。
2. ページ中の"バックアップジョブ"より、リストアさせたい世代のバックアップジョブIDを押下します。
3. "詳細"欄の復旧ポイントARNを押下します。
4. 遷移後画面右上の"復元"を押下します。
5. 遷移後画面下の"ロールを復元"欄の"ロール名"より`{設定したリソース名}-bastion-backup`を選択し、その後ページ下の"バックアップを復元"を押下します。
6. "AWS Backup > ジョブ > 復元ジョブ"よりステータスが"完了"となっていることを確認します。
7. "EC2 > インスタンス"より、インスタンスが再作成されていることを確認してください。

## リストア後にtfstateファイルにサーバー情報を認識させる手順

1. 踏み台サーバー作成時に保管したtfstateファイルをCloudShellにアップロードする。
2. `terraform state rm module.bastion.module.bastion.aws_instance.this`を実行する。
3. `terraform import module.bastion.module.bastion.aws_instance.this {リストアしたインスタンスID}`を実行する。
4. 以下のコマンドを実行してください
```
terraform init
terraform plan
terraform apply
```
5. **ローカル端末に戻り**`{.sshまでのパス}/config`に設定した`Host`の`HostName`を、リストアしたインスタンスIDに変更する・