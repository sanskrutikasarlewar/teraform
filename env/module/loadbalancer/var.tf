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
    type = map(string)
    default = {}
}

variable "subnets" {
    type = list(string)
}
variable "security_groups" {
    type = list(string)
}