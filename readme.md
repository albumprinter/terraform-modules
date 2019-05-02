# Terraform modules

The goal is to have a set of well-designed general purpose Terraform modules that cover the majority of AWS use cases in Albelli.

## Structure of the repository

- src
  - modules
    - _resources (simplest reusable pieces)
      - lambda
    - *pattern 1*
      - main.tf
      - variables.tf
      - output.tf
    - *pattern 2*
      - main.tf
      - variables.tf
      - output.tf
- tests
  - *test 1*
  - *test 2*

## Patterns naming

{trigger}\_{actor}\_{verb}\_{object}

**Examples:**

- sns_lambda_publishes_sqs
- http_lambda_reads_DynamoDB