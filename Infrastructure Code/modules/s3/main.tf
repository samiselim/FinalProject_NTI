data "aws_s3_bucket" "selected" {
  bucket = "fp-statefile-bucket"
}
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "this" {
  bucket = data.aws_s3_bucket.selected.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}
data "aws_iam_policy_document" "s3_bucket_lb_write" {
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.selected.arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = ["${data.aws_s3_bucket.selected.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = ["${data.aws_s3_bucket.selected.arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}