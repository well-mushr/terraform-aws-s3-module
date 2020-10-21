package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBucket(t *testing.T) {
	t.Parallel()

	expectedBucketName := fmt.Sprintf("terratest-s3-bucket-%s", strings.ToLower(random.UniqueId()))
	awsRegion := aws.GetRandomStableRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/s3-complete",
		Upgrade:      true,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": expectedBucketName,
			"region":      awsRegion,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	bucketName := terraform.Output(t, terraformOptions, "bucket_name")
	assert.Equal(t, expectedBucketName, bucketName)

	aws.AssertS3BucketVersioningExists(t, awsRegion, bucketName)
	aws.AssertS3BucketPolicyExists(t, awsRegion, bucketName)
}
