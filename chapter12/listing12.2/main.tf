resource "aws_lambda_function" "lambda" {
  filename      = "code.zip"
  function_name = "${local.namespace}-lambda"
  role          = aws_iam_role.lambda.arn
  handler       = "exports.main"

  source_code_hash = filebase64sha256("code.zip")
  runtime = "nodejs12.x"

  environment {
    variables = {
      USERNAME = var.username
      PASSWORD = var.password
    }
  }
}
