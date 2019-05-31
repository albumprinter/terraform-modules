resource "aws_api_gateway_rest_api" "app" {
  name = "${var.name}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "app" {
  domain_name = "${var.domain_name}"

  certificate_arn = "${var.certificate_arn}"
}

resource "aws_api_gateway_resource" "app_public" {
  rest_api_id = "${aws_api_gateway_rest_api.app.id}"
  parent_id   = "${aws_api_gateway_rest_api.app.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "app_public" {
  rest_api_id   = "${aws_api_gateway_rest_api.app.id}"
  resource_id   = "${aws_api_gateway_resource.app_public.id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "app_public" {
  rest_api_id = "${aws_api_gateway_rest_api.app.id}"
  resource_id = "${aws_api_gateway_method.app_public.resource_id}"
  http_method = "${aws_api_gateway_method.app_public.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_method" "app_public_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.app.id}"
  resource_id   = "${aws_api_gateway_rest_api.app.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "app_public_root" {
  rest_api_id = "${aws_api_gateway_rest_api.app.id}"
  resource_id = "${aws_api_gateway_method.app_public_root.resource_id}"
  http_method = "${aws_api_gateway_method.app_public_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "app" {
  depends_on = [
    "aws_api_gateway_integration.app_public",
    "aws_api_gateway_integration.app_public_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.app.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_base_path_mapping" "app" {
  api_id      = "${aws_api_gateway_rest_api.app.id}"
  stage_name  = "${aws_api_gateway_deployment.app.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.app.domain_name}"
}
