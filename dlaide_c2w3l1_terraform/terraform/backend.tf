# Configure the backend for Terraform using Local Backend
terraform {
  backend "local" {
      ### START CODE HERE ### (~ 1 lines of code)
    path = "/home/coder/.local/share/code-server/User/de-c2w3lab1-273602913277-us-east-1.state" # Path to the local state file
     ### END CODE HERE ###
  }
}