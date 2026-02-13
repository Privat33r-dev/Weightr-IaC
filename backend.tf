terraform {
  backend "s3" {
    bucket  = "weightr-app-tfstate"
    key     = "state.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
