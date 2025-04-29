resource "aws_s3_bucket" "invalid" {
  bucket = "example-corp-assets"
}

resource "aws_s3_bucket" "valid" {
  bucket = "example-com-assets"
}