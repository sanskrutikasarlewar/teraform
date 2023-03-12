resource "aws_lb" "alb" {
  count = var.type == "application" ? 1 : 0
  name  = format("%s-%s-%s", var.appname, var.env, "application")
  internal           = var.internal
  load_balancer_type = var.type
  security_groups    = var.security_groups
  subnets = var.subnets
  //count1 = length(var.public_cidr_block)
  //subnets            = [for subnet in aws_subnet.public : var.public_cidr_block[count1.index].id]
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.log-bucket1.id
    prefix  = var.appname
    enabled = true
  }
  tags = merge(var.tags, {Name= format("%s-%s", "ALB", var.env)})
}

resource "aws_lb" "nlb" {
  count = var.type == "network" ? 1 : 0
  name              = format("%s-%s-%s", var.appname, var.env, "network")
  internal           = var.internal
  load_balancer_type = var.type
  security_groups    = var.security_groups
  subnets = var.subnets
  //security_groups    = ["sg-0dbe5b17c1bfea478"]
  //count1 = length(var.public_cidr_block)
  //subnets            = [for subnet in aws_subnet.public : var.public_cidr_block[count1.index].id]
  enable_deletion_protection = false
  tags = merge(var.tags, {Name= format("%s-%s", "NLB", var.env)})
}

resource "aws_s3_bucket" "log-bucket1" {
   bucket = "logbucket-${var.appname}-${var.env}-${random_string.random.id}"
}

resource "aws_s3_bucket_policy" "log-bucket-policy" {
  bucket = aws_s3_bucket.log-bucket1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.log-bucket1.arn}/*"
      }
    ]
  })
}

resource "random_string" "random" {
  length           = 5
  special          = false
  upper = false
}