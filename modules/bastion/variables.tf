variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "subnet_cidr" {
  description = "サブネットのCIDRブロック"
  type        = string
}

variable "region" {
  description = "VPCのリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "resource_name" {
  description = "各種リソースに付ける共通の名前"
  type        = string
}

variable "instance_type" {
  description = "踏み台サーバーで使うインスタンスタイプ"
  type        = string
}

variable "start_time" {
  description = "踏み台サーバーを起動する時間"
  type        = string
}

variable "stop_time" {
  description = "踏み台サーバーを停止する時間"
  type        = string
}

variable "vpc_id" {
  description = "踏み台サーバーを配置するVPCのID（未指定の場合は自動生成）"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "踏み台サーバーを配置するサブネットのID（未指定の場合は自動生成）"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "サブネットのアベイラビリティゾーン"
  type        = string
  default     = "ap-northeast-1a"
}

variable "generation" {
  description = "バックアップの世代数"
  type        = number
}

variable "assign_eip" {
  description = "EC2にEIPを割り当てるかどうか"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "終了保護を有効にするかどうか"
  type        = bool
  default     = true
}

variable "enable_backup" {
  description = "バックアップ設定を有効にするかどうか"
  type        = bool
  default     = true
}