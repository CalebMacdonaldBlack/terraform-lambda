# Terraform Lambda Function Module
This module is used to create a java8 aws lambda function
## Variables
- `alarm_sns_arn` - The arn of the alarm sns topic
- `env` - The environment
- `file_path` - Path to the jar file
- `handler` - Path for handler
- `name` - Name of the lambda function (Will be prefixed with env)
- `policy_arn` - The arn of the policy
- `identifiers` - List of identifiers for trust role. Default: `["lambda.amazonaws.com"]`
- `memory_size` - The memory for the function. Default: `512`
- `timeout` - The timeout for the function. Default: `300`
- `environment_variables` - Map of environment variables. Default: `{}`
## Usage
```hcl
module "example_lambda" {
  source = "github.com/CalebMacdonaldBlack/terraform-lambda"
  alarm_sns_arn = "${module.alarm-sns-topic.arn}"
  env = "${var.env}"
  file_path = "../../functions/example/target/example.jar"
  handler = "example.core.Example::handleRequest"
  name = "example"
  policy_arn = "${aws_iam_policy.example.arn}"
  identifiers = ["lambda.amazonaws.com", "apigateway.amazonaws.com"]
  memory_size = 128
  timeout = 30
  environment_variables = {foo = "bar"}
}
```
## Outputs
- `arn` - The lambda function arn
- `role_arn` - The lambdas role arn
- `function_name` - The lambda functions name
