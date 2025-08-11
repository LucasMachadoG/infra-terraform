resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "static-site-${var.bucket_name}"

  tags = {
    Name        = "Static Site Bucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
  bucket                  = aws_s3_bucket.static_site_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket" {
  depends_on = [
    aws_s3_bucket_public_access_block.static_site_bucket,
    aws_s3_bucket_ownership_controls.static_site_bucket
  ]
  bucket = aws_s3_bucket.static_site_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  index_document { suffix = "index.html" }
  error_document { key    = "index.html" }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "PublicReadGetObject"
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals { type = "AWS", identifiers = ["*"] }
    resources = ["${aws_s3_bucket.static_site_bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.static_site_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}
