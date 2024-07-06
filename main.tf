#Local module
module "compute" {
  source = "./ec2"
}


module "security" {
  source = "./iam"
  

}
#Module from registry
module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
}