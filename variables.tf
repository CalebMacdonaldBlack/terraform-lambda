variable "alarm_sns_arn" { }
variable "env" {}
variable "environment_variables" {}
variable "memory_size" {
  default = "512"
}
variable "timeout" {
  default = "300"
}
variable "file_path" {}
variable "handler" {}
variable "name" {}
variable "role_name" {}
variable "role_arn" {}
variable "policy_arn" {}
