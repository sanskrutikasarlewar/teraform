provider "aws" {
    profile = "Anita1"
    region= "ap-southeast-2"
}
module "s3-bucket" {
    source = "../s3-bucket"
    name = "auto-name"
    env= "prod"
    vpc_cidr_block = "10.0.0.0/16"
    //name_prefix = "prefixx"
    ami_id = "ami-0d95c7ccb8286fada"
    instance_type = "t2.micro"
    security_groups = ["sg-0dbe5b17c1bfea478"]
    subnets = ["subnet-0c5a80271d4af577f"]
    min_size = "1"
    max_size = "3"
    scale_up_cooldown = "3"
    scale_down_cooldown = "2"  
    //cpu_utilization_threshold = "100cpu" 
}