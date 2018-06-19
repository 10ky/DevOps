resource "aws_s3_bucket" "wildrydesr_bucket" {
  bucket = "wildrydes-steve-liang-bucket-${var.stage}"
  acl    = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
  }
  server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       sse_algorithm     = "AES256"
     }
   }
 }
  tags {
    Name  = "wildrydes-steve-liang-bucket-${var.stage}"
    stage = "${var.stage}"
  }
}

resource "aws_s3_bucket_policy" "wildrydesr_bucket" {
  bucket = "${aws_s3_bucket.wildrydesr_bucket.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.wildrydesr_bucket.id}/*"
    }
  ]
}
POLICY
}
