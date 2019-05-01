provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

resource "aws_iam_user" "loom" {
    name = "${var.full_user}"
    path = "/loom/"
    tags = {
        Name = "Loom"
        Environment = "prod"
    }
}

resource "aws_iam_access_key" "loom" {
  user = "${aws_iam_user.loom.name}"
}

resource "aws_iam_user" "loom-external" {
    name = "${var.external_user}"
    path = "/loom/"
    tags = {
        Name = "Loom"
        Environment = "prod"
    }
}

resource "aws_iam_access_key" "loom-external" {
  user = "${aws_iam_user.loom-external.name}"
}

resource "aws_s3_bucket" "loom" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags = {
    Name        = "Loom"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_policy" "loom-bucket-access" {
    bucket = "${aws_s3_bucket.loom.id}"
    policy = "${data.aws_iam_policy_document.loom-bucket-access.json}"
}

data "aws_iam_policy_document" "loom-bucket-access" {
  statement {
    principals {
        type = "AWS"
        identifiers = ["${aws_iam_user.loom.arn}"]
    }

    actions   = ["s3:*"]
    resources = [
        "${aws_s3_bucket.loom.arn}",
        "${aws_s3_bucket.loom.arn}/*", 
    ]
  }

  statement {
    principals {
        type = "AWS"
        identifiers = ["${aws_iam_user.loom-external.arn}"]
    }
    
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.loom.arn}"]
    condition {
        test = "StringLike"
        variable = "s3:prefix"

        values = [
            "",
            "external/",
        ]
    }
  }

  statement {
    principals {
        type = "AWS"
        identifiers = ["${aws_iam_user.loom-external.arn}"]
    }

    actions   = [
        "s3:PutObject",
        "s3:PutObjectAcl",
    ]
    resources = [
        "${aws_s3_bucket.loom.arn}/external/",
        "${aws_s3_bucket.loom.arn}/external/*"
    ]

  }
}