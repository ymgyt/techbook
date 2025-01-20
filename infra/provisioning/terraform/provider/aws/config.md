# AWS Config

```hcl

terraform {
  required_version = ">= 1.9.8"

  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
}

import {
  id = "aws-controltower-BaselineConfigRecorder"
  to = aws_config_configuration_recorder_status.ct_baseline
}

resource "aws_config_configuration_recorder_status" "ct_baseline" {
  is_enabled = true
  name       = "aws-controltower-BaselineConfigRecorder"
}

import {
  id = "aws-controltower-BaselineConfigRecorder"
  to = aws_config_configuration_recorder.ct_baseline
}

resource "aws_config_configuration_recorder" "ct_baseline" {
  name     = "aws-controltower-BaselineConfigRecorder"
  role_arn = "arn:aws:iam::<account>:role/aws-controltower-ConfigRecorderRole"
  recording_group {
    all_supported                 = true
    include_global_resource_types = true
    resource_types                = []
    exclusion_by_resource_types {
      resource_types = []
    }
    recording_strategy {
      use_only = "ALL_SUPPORTED_RESOURCE_TYPES"
    }
  }

}
```

