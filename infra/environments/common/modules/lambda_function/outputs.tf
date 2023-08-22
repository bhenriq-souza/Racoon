output "api_gateway_url" {
  description = "API Gateway URL"
  value       = "https://${aws_api_gateway_rest_api.api[0].id}.execute-api.${var.region}.amazonaws.com/${var.environment}"
  depends_on  = [aws_api_gateway_rest_api.api]
}
