resource "aws_lb" "alb" {
  count                      = var.type == "application" ? 1 : 0
  name                       = format("%s-%s-%s", var.appname, var.env, "application")
  internal                   = var.internal
  load_balancer_type         = var.type
  security_groups            = var.security_groups
  subnets                    = var.subnets
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.log-bucket.id
    prefix  = var.appname
    enabled = true
  }
  tags = merge(var.tags, { Name = format("%s-%s", "ALB", var.env) })
}

resource "aws_lb" "nlb" {
  count                      = var.type == "network" ? 1 : 0
  name                       = format("%s-%s-%s", var.appname, var.env, "network")
  internal                   = var.internal
  load_balancer_type         = var.type
  subnets                    = var.subnets
  enable_deletion_protection = false
  tags                       = merge(var.tags, { Name = format("%s-%s", "NLB", var.env) })
}

resource "aws_lb_listener" "static" {
  count             = var.type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_target_group" "this" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc
}

resource "aws_lb_listener_rule" "static" {
  for_each     = var.listener_rule
  listener_arn = aws_lb_listener.static[0].arn
  priority     = each.value.priority

  action {
    type             = each.value.type
    target_group_arn = each.value.target_group_arn
  }

  condition {
    path_pattern {
      values = each.value.values
    }
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.as_group_name
  lb_target_group_arn    = aws_lb_target_group.this.arn
}

/*---------------S3 Bucket----------------*/
resource "aws_s3_bucket" "log-bucket" {
  bucket        = "logbucket-${var.appname}-${var.env}-${random_string.random.id}"
  force_destroy = true
}
resource "random_string" "random" {
  length  = 5
  special = false
  upper   = false
}

/*---------------S3 Access log Policy----------------*/
resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket = aws_s3_bucket.log-bucket.id
  policy = data.aws_iam_policy_document.policy.json
}
data "aws_iam_policy_document" "policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.log-bucket.id}/${var.appname}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    actions   = ["s3:PutObject"]

    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.main.arn]
    }
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.log-bucket.id}/${var.appname}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:s3:::${aws_s3_bucket.log-bucket.id}"]
    actions   = ["s3:GetBucketAcl"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}
data "aws_caller_identity" "current" {}
data "aws_elb_service_account" "main" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

