resource "aws_lambda_function" "test_lambda" {
  filename         = "index.zip"
  function_name    = "RequestUnicorn"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("index.zip"))}"
  runtime          = "nodejs6.10"
}
