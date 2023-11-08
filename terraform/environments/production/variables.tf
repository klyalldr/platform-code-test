data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "main_public" {
  name         = var.dns_public_domain
  private_zone = false
}


variable "app_rds_master_username" {
  type    = string
  default = "root"
}

variable "app_name" {
  type    = string
  default = "platform-code-test-app"
}

variable "app_image" {
  type    = string
  default = "920609328416.dkr.ecr.eu-west-1.amazonaws.com/platform-code-test-app:0.0.8"
}

variable "dns_public_domain" {
  type    = string
  default = "roo-coding-test.co.uk"
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "subnet_cidr_apps_a" {
  type    = string
  default = "10.0.0.0/19"
}

variable "subnet_cidr_dbs_a" {
  type    = string
  default = "10.0.96.0/19"
}

variable "subnet_cidr_dbs_b" {
  type    = string
  default = "10.0.128.0/19"
}

variable "subnet_cidr_dbs_c" {
  type    = string
  default = "10.0.160.0/19"
}

variable "subnet_cidr_public_a" {
  type    = string
  default = "10.0.192.0/20"
}

variable "subnet_cidr_public_b" {
  type    = string
  default = "10.0.208.0/20"
}

variable "subnet_cidr_public_c" {
  type    = string
  default = "10.0.224.0/20"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
