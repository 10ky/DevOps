resource "aws_api_gateway_rest_api" "wild_rydes" {
  name = "wild-rydes-${var.stage}"
  description = "API Gateway Service Lambda"
}

resource "aws_api_gateway_authorizer" "wild_rydes" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = "${aws_api_gateway_rest_api.wild_rydes.id}"
  provider_arns = ["${aws_cognito_user_pool.wild_rydes.arn}"]
}

resource "aws_api_gateway_resource" "ride" {
  rest_api_id = "${aws_api_gateway_rest_api.wild_rydes.id}"
  parent_id = "${aws_api_gateway_rest_api.wild_rydes.root_resource_id}"
  path_part = "ride"
}

resource "aws_api_gateway_method" "options_method" {
    rest_api_id   = "${aws_api_gateway_rest_api.wild_rydes.id}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    http_method   = "OPTIONS"
    authorization = "NONE"
}

resource "aws_api_gateway_method" "wild_rydes" {
  rest_api_id = "${aws_api_gateway_rest_api.wild_rydes.id}"
  resource_id = "${aws_api_gateway_resource.ride.id}"
  http_method = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = "${aws_api_gateway_authorizer.wild_rydes.id}"
}

resource "aws_api_gateway_integration" "options_integration" {
    rest_api_id   = "${aws_api_gateway_rest_api.wild_rydes.id}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    http_method   = "${aws_api_gateway_method.options_method.http_method}"
    type          = "MOCK"
    depends_on = ["aws_api_gateway_method.options_method"]
}

resource "aws_api_gateway_integration" "wild_rydes" {
  rest_api_id = "${aws_api_gateway_rest_api.wild_rydes.id}"
  resource_id = "${aws_api_gateway_method.wild_rydes.resource_id}"
  http_method = "${aws_api_gateway_method.wild_rydes.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.test_lambda.invoke_arn}"
}

resource "aws_api_gateway_method_response" "wild_rydes" {
    rest_api_id   = "${aws_api_gateway_rest_api.wild_rydes.id}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    http_method   = "${aws_api_gateway_method.wild_rydes.http_method}"
    status_code   = "200"
    response_models {
        "application/json" = "Empty"
    }
}

resource "aws_lambda_permission" "wild_rydes_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_deployment.wild_rydes.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "wild_rydes" {
  depends_on = [
    "aws_api_gateway_method.wild_rydes",
    "aws_api_gateway_integration.wild_rydes"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.wild_rydes.id}"
  stage_name = "${var.stage}"
}

