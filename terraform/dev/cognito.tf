resource "aws_cognito_user_pool" "wild_rydes" {
  name = "wild-rydes-${var.stage}"

  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "wild_rydes_web_app" {
  name = "wild-rydes-web-app-${var.stage}"

  user_pool_id = "${aws_cognito_user_pool.wild_rydes.id}"
}
