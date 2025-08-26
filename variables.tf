variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "サブネットのCIDRブロック"
  type        = string
  default     = "10.0.1.0/24"
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
  default     = "t2.medium"
}

variable "start_time" {
  description = "踏み台サーバーを起動する時間"
  type        = string
  default     = "cron(55 8 ? * MON-FRI *)"
}

variable "stop_time" {
  description = "踏み台サーバーを停止する時間"
  type        = string
  default     = "cron(0 19 ? * MON-FRI *)"
}

variable "vpc_id" {
  description = "踏み台サーバーを配置するVPCのID"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "踏み台サーバーを配置するサブネットのID"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "アベイラビリティゾーン"
  type        = string
  default     = "ap-northeast-1a"
}

variable "generation" {
  description = "バックアップの世代数"
  type        = number
  default     = 10
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