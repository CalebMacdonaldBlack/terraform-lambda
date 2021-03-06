data "aws_iam_policy_document" "trust" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {

      identifiers = "${var.identifiers}"
      type = "Service"
    }
  }
}

#role for executing solar data function
resource "aws_iam_role" "role" {
  name = "${var.env}-${var.name}"
  path = "/service-role/"
  assume_role_policy = "${data.aws_iam_policy_document.trust.json}"
}

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
  role = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.logs.arn}"
}

resource "aws_iam_role_policy_attachment" "policy" {
  policy_arn = "${var.policy_arn}"
  role = "${aws_iam_role.role.name}"
}

resource "aws_lambda_function" "lambda" {
  function_name = "${var.env}-${var.name}"
  role = "${aws_iam_role.role.arn}"
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
  function_name = "${aws_lambda_function.lambda.function_name}"
  alarm_sns_arn = "${var.alarm_sns_arn}"
}
