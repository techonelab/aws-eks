variable vpc_cidr_main {}
variable "project" {}
variable "az_count" {}
variable "subnet_cidr_bits" {}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "demo-aks-eks"
    "Environment" = "beta"
    "Owner"       = "techjuanlab"
  }
}