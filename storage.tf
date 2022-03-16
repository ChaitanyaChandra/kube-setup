#variable "state_bucket" {
#  type    = string
#  default = "s3-state-tf"
#}
#
#resource "aws_s3_bucket" "state"{
#  bucket	= "${var.state_bucket}-${local.tags.Service}-${local.region}-${local.env_tag.appenv}"
#  acl		= "private"
#}
#
#terraform {
#  backend "s3" {
#    bucket = "devops-catalog"
#    key    = "terraform/state"
#  }
#}