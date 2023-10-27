variable "vpc-cidr" {
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet-cidr-apps-a" {
  type        = string
  default     = "10.0.0.0/20"
}

variable "subnet-cidr-dbs-a" {
  type        = string
  default     = "10.0.128.0/20"
}

variable "region" {
  type        = string
  default     = "eu-west-1"
}
