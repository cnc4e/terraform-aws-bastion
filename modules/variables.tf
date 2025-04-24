variable "resouce_name" {
  description = "Requested instance type"
  type        = string
}

variable "instance_type" {
  description = "Requested instance type"
  type        = string
}

variable "start_time" {
  description = "Time to start up the bastion server"
  type        = string
}

variable "stop_time" {
  description = "Time to shut down the bastion server"
  type        = string
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