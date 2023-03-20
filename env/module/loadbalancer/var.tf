variable "type" {
  type = string
}

variable "internal" {
  type = string
}

variable "env" {
  type = string
}

variable "appname" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = set(string)
}

variable "vpc" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "listener_rule" {
  type = any
}

variable "as_group_name" {
  type = string
}