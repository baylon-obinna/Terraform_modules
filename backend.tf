#Before using this create and s3 bucket and implement a dynamodb table to it.

#This block of code stores the terraform.tfstate file securely in the specified s3 bucket.

#The dynamodb table is hold the terraform-lock to a particular user that triggered a change.
#This is to avoid data lose and inaccurate terraform.tfstate file 


/*terraform {
  backend "s3" {
    bucket         = "abhishek-s3-demo-xyz" # change this
    key            = "abhi/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}*/