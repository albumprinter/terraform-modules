provider "aws" {
  region = "eu-west-1"
}

module "label" {
  source      = "../../../modules/resources/label"
  application = "test-app"
  name        = "app"
  environment = "test"
  domain      = "ci-cd platform"
  cost_center = "3600"
  team        = "customer care technology"
}

module "test" {
  source = "../../../modules/resources/cw/log_group"
  name   = "test-cw-log"
  tags   = "${module.label.tags}"
}
