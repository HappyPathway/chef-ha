variable "key_name" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "chef_config_path" {}
variable "chef_config_bucket" {}
variable "chef_cluster_master" {}
variable "chef_iam_instance_role" {}
variable "chef_auth_cidr_addresses" {
    default = "0.0.0.0/0"
}
variable "chef_environment" {
    default = "_default"
}
variable "nodename" {}
variable "chef_version" {
    default = "14.12.9"
}

variable "os_version" {
    default = "18.04"
}

variable "os_nickname" {
    default = "bionic"
}


variable "chef_backend_version" {
    default = "2.0.1"
}

variable "chef_frontend_version" {
    default = "12.19.31"
}

variable "chef_slave_count" {
    default = 1
}