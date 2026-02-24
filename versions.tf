terraform {
  required_version = ">= 1.8.5"

  required_providers {
    aws = {
      version = ">= 5.58.0"
      source  = "hashicorp/aws"
    }
  }

  # ============================================================================
  # 【tfstateの管理方法の選択】
  # ============================================================================
  #
  # ■ ローカルで管理する場合（デフォルト）:
  #   以下のbackendブロックをコメントアウトしたままにしてください。
  #   tfstateはCloudShellのローカルに保存されます。
  #   ※ CloudShellのボリュームは一時的なものです。
  #     踏み台サーバーを削除する際に必要となるため、
  #     tfstateを必ずローカル端末にダウンロードして保管してください。
  #
  # ■ S3バックエンドで管理する場合:
  #   以下のbackendブロックのコメントアウトを解除してください。
  #   ただし、初回実行時はS3バケットがまだ存在しないため、
  #   terraform applyでS3バケットを作成した後にコメントアウトを解除してください。
  #
  # 注意: backend blockでは変数が使用できないため、バケット名は直接指定する必要があります。
  #       terraform.tfvarsのtfstate_bucket_nameと一致させてください。
  # ============================================================================

  # backend "s3" {
  #   bucket       = "terraform-aws-bastion-tfstate"
  #   key          = "bastion.tfstate"
  #   region       = "ap-northeast-3"
  #   encrypt      = true
  #   use_lockfile = true
  # }
}

provider "aws" {
  region = var.region
}