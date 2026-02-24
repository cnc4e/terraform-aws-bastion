terraform {
  required_version = ">= 1.8.5"

  required_providers {
    aws = {
      version = ">= 5.58.0"
      source  = "hashicorp/aws"
    }
  }

  # ============================================================================
  # 【初回実行時の注意事項】
  # ============================================================================
  # このbackend設定は初回のTerraform実行時にエラーとなります。
  # （バックエンドで指定したS3バケットがまだ存在しないため）
  #
  # 初回実行時の手順:
  # 1. 以下のbackendブロック全体をコメントアウトする
  # 2. terraform init を実行
  # 3. terraform apply を実行（S3バケット等のリソースが作成される）
  # 4. backendブロックのコメントアウトを解除
  # 5. terraform init を再実行
  #    → ローカルのtfstateをリモートにアップロードするか聞かれるので「yes」と入力
  #
  # 注意: backend blockでは変数が使用できないため、バケット名は直接指定する必要があります
  #       terraform.tfvarsのtfstate_bucket_nameと一致させてください
  # ============================================================================
  backend "s3" {
    bucket       = "terraform-aws-bastion-tfstate"
    key          = "bastion.tfstate"
    region       = "ap-northeast-3"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}