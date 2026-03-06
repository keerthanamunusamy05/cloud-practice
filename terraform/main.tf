provider "aws" {
    region = "ap-south-1"
}

resource "aws_s3_bucket" "websitebucket" {
    bucket = "keerthanademo-website-route53"

tags = {
    name = "Static Website"
}
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.websitebucket.id
index_document {
  suffix = "index.html"
}
}
 resource "aws_cloudfront_distribution" "cdn" {
   origin {
     domain_name = aws_s3_bucket.websitebucket.bucket_regional_domain_name
     origin_id = "s3origin"
   }
   enabled = true
   default_cache_behavior {
     allowed_methods = ["GET","HEAD"]
     cached_methods = ["GET","HEAD"]
     target_origin_id = "s3origin"
     viewer_protocol_policy = "redirect-to-https"
   }
   default_root_object = "index.html"
   restrictions {
     geo_restriction {
       restriction_type = "none"
     }
   }
   viewer_certificate {
     cloudfront_default_certificate = true
   }
 }

 