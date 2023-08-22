locals {
  env = basename(dirname(get_original_terragrunt_dir()))
  component = basename(get_terragrunt_dir())
}

# Include the root terragrunt.hcl
include "common"{
  path = "../common.hcl"
  merge_strategy = "deep"

}


# Including the Public EKS Template
include "public-eks"{
  path = "../../_templates/public-eks.hcl"
  # path = "${get_path_to_repo_root()}/_templates/public-eks.hcl"
  # path = "${get_terragrunt_dir()}/../../../_templates/public-eks.hcl"
  merge_strategy = "deep"
}