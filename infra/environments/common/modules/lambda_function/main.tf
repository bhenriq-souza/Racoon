resource "aws_lambda_function" "lambda" {
  function_name = var.function_name
  role          = var.role
  image_uri     = var.image_uri
  timeout       = var.timeout
  memory_size   = var.memory_size

  package_type = "Image"

  tracing_config {
    mode = "PassThrough"
  }

  environment {
    variables = var.environment_variables
  }
}

resource "aws_api_gateway_rest_api" "api" {
  count = var.enable_api_gateway ? 1 : 0
  name  = var.api_name
  description = "API for ${var.function_name} lambda function"
  
  endpoint_configuration {
    types = ["EDGE"]
  }
}

resource "aws_api_gateway_resource" "resource" {
  count = var.enable_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api[0].id
  parent_id   = aws_api_gateway_rest_api.api[0].root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  count = var.enable_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api[0].id
  resource_id = aws_api_gateway_resource.resource[0].id
  http_method = var.api_method
  authorization = var.api_gateway_authorization
}

resource "aws_api_gateway_integration" "lambda" {
  count = var.enable_api_gateway ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.api[0].id
  resource_id = aws_api_gateway_resource.resource[0].id
  http_method = aws_api_gateway_method.proxy[0].http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn

  depends_on = [
    aws_lambda_function.lambda
  ]
}

resource "aws_lambda_permission" "apigw" {
  count = var.enable_api_gateway ? 1 : 0
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.api[0].id}/*/${aws_api_gateway_method.proxy[0].http_method}${aws_api_gateway_resource.resource[0].path}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api[0].id
  stage_name  = var.environment

  depends_on = [
    aws_api_gateway_method.proxy,
    aws_api_gateway_integration.lambda
  ]
}
