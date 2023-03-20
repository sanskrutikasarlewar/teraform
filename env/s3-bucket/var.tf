# modules/autoscaling/variables.tf
variable "vpc_cidr_block" {
  type        = string
  description = "The name of the Auto Scaling group."
}
variable "env" {
  type        = string
  description = "The name of the Auto Scaling group."
}
variable "name" {
  type        = string
  description = "The name of the Auto Scaling group."
}

/*variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources."
  default     = "example"
}*/

variable "ami_id" {
  type        = string  //description = "The ID of the AMI to use for the launch configuration."
}


variable "instance_type" {
  type        = string
  description = "The instance type to use for the launch configuration."
}

variable "security_groups" {
  type        = set(string)
  description = "List of security group IDs to associate with instances in the Auto Scaling group."
}

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to launch the Auto Scaling group instances in."
}

variable "min_size" {
  type        = string
}
variable "max_size" {
  type        = string
}
variable "scale_up_cooldown" {
  type        = string
}
variable "scale_down_cooldown" {
  type        = string
}
/*variable "tags" {
    default = ""
}*/

