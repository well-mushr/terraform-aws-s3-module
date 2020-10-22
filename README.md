
# Terraform module to manage AWS S3 Bucket

Terraform module which creates S3 bucket on AWS.

These S3 bucket features are supported.

* acl
* versioning
* lifecyle rules
* server-side encryption
* logging

## Usage

**Private bucket using versioning, policy and lifecyle_rule**

```terraform
module "s3" {
  source = "github.com/wmaramos/terraform-aws-s3-module"

  bucket_name = "my-s3-bucket"
  acl         = "private"

  policy = file("./bucket_policy.json")

  versioning = {
    enabled = true
  }

  lifecyle_rule = [
    {
      rule_name = "transition-rule"
      enabled   = true

      transition = [
        {
          days          = 90
          storage_class = "STANDARD_IA"
        },
        {
          days          = 360
          storage_class = "GLACIER"
        }
      ]
    }
  ]
}
```

## Examples

* [Complete](https://github.com/wmaramos/terraform-aws-s3-module/blob/main/examples/s3-complete/main.tf) - Complete S3 bucket with the most supported features of the module.

## Pre-commit
It's strong recommend use [pre-commit framework](https://pre-commit.com/), there specialize hooks configured in this project to help maintain a good code.

You can see more details directly in the site framework but a simple way to install is using homebrew.
```
brew install pre-commit
```

The [specilized hooks](https://github.com/antonbabenko/pre-commit-terraform) used by terraform needs some packages too. Again the easiest way is using homebrew.
```
brew install gawk terraform-docs tflint coreutils
```

## Tests
This module also supports tests using [terratest](https://github.com/gruntwork-io/terratest), the easiest way to run is using [docker-compose](https://docs.docker.com/compose/) and `make`.
```
make test
```

The tests requires valid AWS credential exported in your shell with access to AWS S3.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.4, < 0.14.0 |
| aws | >= 3.11, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.11, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | (Optional) The canned ACL to apply | `string` | `"private"` | no |
| bucket\_name | (Optional, Forces new resource) The bucket of the bucket. If omitted Terraform will assign a random, unique name. | `string` | `null` | no |
| lifecycle\_rule | (Optional) List of maps containing a configuration of object lifecycle management | `any` | `[]` | no |
| logging | (Optional) Map of strings defining the logging settings. | `map(string)` | `{}` | no |
| policy | (Optional) A valid bucket policy JSON document | `string` | `null` | no |
| server\_side\_encryption | (Optional) A configuration of server-side encryption | `map(string)` | <pre>{<br>  "sse_algorithm": "aws:kms"<br>}</pre> | no |
| tags | (Optional) Specifies a map object used to create tags. | `map(string)` | `{}` | no |
| versioning | (Optional) Map containing a state of versioning configuration. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | The arn of the bucket |
| bucket\_name | The name of the bucket |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->