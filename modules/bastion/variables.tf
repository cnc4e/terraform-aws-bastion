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

variable "resouce_name" {
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

variable "timezone" {
  description = "踏み台サーバーを起動・停止する時間のタイムゾーン"
  type        = string
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
  default     = "ap-northeast-3a"
}

variable "generation" {
  description = "バックアップの世代数"
  type        = number
}