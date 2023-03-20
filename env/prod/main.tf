provider "aws" {
  profile = "sans1"
  region  = "ap-southeast-1"
}

module "vpc" {
  source             = "../module/vpc"
  vpc_cidr_block     = "172.168.0.0/16"
  appname            = "vpc-lb"
  env                = "prod"
  public_cidr_block  = ["172.168.1.0/24", "172.168.2.0/24"]
  private_cidr_block = ["172.168.3.0/24", "172.168.4.0/24"]
  availability_zone  = ["ap-southeast-1a", "ap-southeast-1b"]
  tags = {
    Owner = "Sanskruti"
  }
}

module "Loadbalancer" {
  source          = "../module/Loadbalancer"
  env             = "prod"
  type            = "application"
  internal        = "false"
  instance_type   = "t3.micro"
  appname         = "lb-appname"
  vpc             = module.vpc.vpc_id
  subnets         = module.vpc.subnets_id
  security_groups = [module.vpc.security_groups]
  tags = {
    Owner = "prod_team"
  }
  listener_rule = {
    laptop = {
      priority         = "10"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:948511390743:targetgroup/target-group/7cab487114206038"
      values           = ["/laptop"]
    }
    mobile = {
      priority         = "20"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:948511390743:targetgroup/target-group/7cab487114206038"
      values           = ["/mobile"]
    }
    tab = {
      priority         = "30"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:ap-southeast-1:948511390743:targetgroup/target-group/7cab487114206038"
      values           = ["/tab"]
    }
  }
  as_group_name = module.autoscaling.autoscaling_group_name
}

module "autoscaling" {
  source          = "../module/autoscaling"
  appname         = "student"
  env             = "prod"
  security_groups = [module.vpc.security_groups]
  /* subnets             = module.vpc.subnets_id */
  vpc_zone_identifier = module.vpc.subnets_id
  instance_type       = "t2.micro"
  user_data_base64    = "IyEvYmluL2Jhc2gKc3VkbyBhcHQtZ2V0IHVwZGF0ZQpzdWRvIGFwdC1nZXQgaW5zdGFsbCBuZ2lueCAteQpzdWRvIHN5c3RlbS1jb250ZW50IHN0YXJ0IG5naW54CgpjZCAvdmFyL3d3dy9odG1sCmVjaG8gIkhlbGxvLCBUZXJyYWZvcmYgJiBBV1MgQVNHIiA+IGluZGV4Lmh0bWw="
  min_size            = 1
  max_size            = 3
  desired_capacity    = 2
  policy_type         = "SimpleScaling" #"SimpleScaling"  #"target_tracking_policy" #"StepScaling"
  tags = {
    Owner = "prod-team"
  }
}

