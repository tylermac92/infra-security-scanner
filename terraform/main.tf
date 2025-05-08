resource "aws_s3_bucket" "example" {
  bucket = "infra-sec-example-bucket-${random_id.bucket_id.hex}"
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
