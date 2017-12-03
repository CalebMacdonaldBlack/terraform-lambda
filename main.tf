data "aws_iam_policy_document" "logs" {

  statement {

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_policy" "logs" {
  name = "${var.env}-${var.name}-logs"
  path = "/"
  policy = "${data.aws_iam_policy_document.logs.json}"
}

resource "aws_iam_role_policy_attachment" "logs" {
  role = "${var.role_name}"
  policy_arn = "${aws_iam_policy.logs.arn}"
}

resource "aws_iam_role_policy_attachment" "policy" {
  policy_arn = "${var.policy_arn}"
  role = "${var.role_name}"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.env}-${var.name}"
  role = "${var.role_arn}"
  handler = "${var.handler}"
  filename = "${var.file_path}"
  runtime = "java8"
  memory_size = "${var.memory_size}"
  timeout = "${var.timeout}"

  environment {
    variables = "${var.environment_variables}"
  }
}

module "alarms" {
  source = "github.com/CalebMacdonaldBlack/terraform-lambda-errors"
  env = "${var.env}"
  function_name = "${aws_lambda_function.lambda.function_name}"
}
