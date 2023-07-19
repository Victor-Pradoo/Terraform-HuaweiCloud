terraform {
  backend "s3" {
    bucket = "obs-terraform"
    key = "network/terraform.tfstate"
    region = "sa-brazil-1"
    endpoint = "obs.sa-brazil-1.myhuaweicloud.com"
    skip_region_validation = true
    skip_metadata_api_check = true
    skip_credentials_validation = true
  }
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.51.0"
    }
  }
}
