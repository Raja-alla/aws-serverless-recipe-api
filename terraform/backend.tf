terraform {
  backend "s3" {
    bucket = "terraforrm-state-bucket-p1"
    key    = ".P2/terraform.tfstate"
    region = "ap-south-1"
  }
}