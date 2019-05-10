variable "region" {
  default = "eu-west-1"
}

provider "aws" {
  region = "${var.region}"
}

module "label" {
  source      = "./modules/resources/label"
  application = "backoffice"
  name        = "spa"
  environment = "test"
  attributes  = ["experimental"]
  service     = "Customer Care"
  cost_center = "3600"
  team        = "customer care technology"
}

module "test" {
  source         = "./modules/resources/lambda/plain"
  name           = "${module.label.id}"
  role_arn       = "arn:aws:iam::884394444434:role/backoffice_lambda"
  handler        = "test"
  s3_bucket_name = "cct-lambda-storage"
  s3_bucket_path = "dotnet_sample.zip"
  tags           = "${module.label.tags}"

  providers = {
    aws = "aws"
  }
}

output out1 {
  value = "${module.test.arn}"
}
