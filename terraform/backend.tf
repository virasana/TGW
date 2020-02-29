terraform {
  backend "s3" {
    bucket = "ksone-tgw"
    key    = "tgw.tfstate"
    region = "eu-west-2"
  }
}