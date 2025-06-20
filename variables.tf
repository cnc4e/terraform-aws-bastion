variable "resouce_name" {
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

variable "timezone" {
  description = "踏み台サーバーを起動・停止する時間のタイムゾーン"
  type        = string
  default     = "Asia/Tokyo"
}

variable "vpc_id" {
  description = "踏み台サーバーを配置するVPCのID"
  type        = string
}

variable "subnet_id" {
  description = "踏み台サーバーを配置するサブネットのID"
  type        = string
}

variable "generation" {
  description = "バックアップの世代数"
  type        = number
  default     = 10
}