provider "aws" {
    profile = "Anita1"
    region= "ap-southeast-2"
}

module "vpc" {
    source = "../module/vpc"
    vpc_cidr_block = "192.168.0.0/16"
    appname = "vpc-appname"
    env = "dev"
    public_cidr_block = ["192.168.1.0/24" , "192.168.2.0/24"]
    private_cidr_block = ["192.168.3.0/24" , "192.168.4.0/24"]
    availability_zone = ["ap-southeast-2a","ap-southeast-2b"]
    tags = {
        Owner = "Sanskruti"
    }
}

module "loadbalancer" {
    source = "../module/loadbalancer"
    env = "prod"
    type = "application"
    internal = "false"
    appname = "lb-appname"
    subnets = module.vpc.public_subnets_ids
    security_groups = [module.vpc.security_groups]
    tags = {
        Owner = "prod_team"
    }
}