package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBucket(t *testing.T) {
	t.Parallel()

	seed := time.Now().UTC().UnixNano()

	expectedBucketName := fmt.Sprintf("%s-%d", "terratest-s3-bucket", seed)
	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/s3-complete",
		Upgrade:      true,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket": expectedBucketName,
			"region": "us-east-1",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	bucketName := terraform.Output(t, terraformOptions, "bucket")
	assert.Equal(t, expectedBucketName, bucketName)
}
