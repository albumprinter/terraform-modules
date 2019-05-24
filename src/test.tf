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
  environment = "Test"
  attributes  = ["Experimental"]
  domain      = "ci/cd"
  cost_center = "3600"
  team        = "customer care technology"
}

# module "test" {
#   source    = "./modules/resources/dynamo/hash_and_range"
#   name      = "${module.label.id}"
#   hash_key  = "Column1"
#   range_key = "Column2"
#   tags      = "${module.label.tags}"

#   providers = {
#     aws = "aws"
#   }
# }

output out1 {
  value = "${module.test.arn}"
}
