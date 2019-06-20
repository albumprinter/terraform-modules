provider "aws" {
  region = "eu-west-1"
}

module "label" {
  source      = "../../modules/resources/label"
  application = "test-app"
  name        = "app"
  environment = "test"
  domain      = "ci-cd platform"
  cost_center = "3600"
  team        = "customer care technology"
}

module "test" {
  source           = "../../modules/patterns/cw_error_sns"
  app_name         = "test-app"
  log_group_prefix = "/test/"
  emails           = ["salavat.galiamov@albelli.com"]
  tags             = "${module.label.tags}"
}
