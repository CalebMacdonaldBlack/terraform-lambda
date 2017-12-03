variable "alarm_sns_arn" { }
variable "env" {}
variable "file_path" {}
variable "handler" {}
variable "name" {}
variable "policy_arn" {}
variable "identifiers" {
  type = "list"
  default = ["lambda.amazonaws.com"]
}
variable "memory_size" {
  default = "512"
}
variable "timeout" {
  default = "300"
}
variable "environment_variables" {
  type = "map"
  default = { }
}
