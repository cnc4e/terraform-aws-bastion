variable "resouce_name" {
  description = "Name for each resource"
  type        = string
}

variable "instance_type" {
  description = "Requested instance type"
  type        = string
  default     = "t2.medium"
}

variable "start_time" {
  description = "Time to start up the bastion server"
  type        = string
  default     = "cron(55 8 * * ? *)"
}

variable "stop_time" {
  description = "Time to shut down the bastion server"
  type        = string
  default     = "cron(0 19 * * ? *)"
}

variable "timezone" {
  description = "Time zone in which the user is located"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the bastion server is located"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the bastion server is located"
  type        = string
}