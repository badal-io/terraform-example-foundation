/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  env              = "development"
  environment_code = substr(local.env, 0, 1)
  default_region1  = "us-west1"
  default_region2  = "us-central1"
  /*
   * Base network ranges
   */
  base_private_service_cidr = "10.16.64.0/21"
  base_subnet_primary_ranges = {
    (local.default_region1) = "10.0.64.0/21"
    (local.default_region2) = "10.1.64.0/21"
  }
  base_subnet_secondary_ranges = {
    (local.default_region1) = [
      {
        range_name    = "rn-${local.environment_code}-shared-base-${local.default_region1}-gke-pod"
        ip_cidr_range = "100.64.64.0/21"
      },
      {
        range_name    = "rn-${local.environment_code}-shared-base-${local.default_region1}-gke-svc"
        ip_cidr_range = "100.64.72.0/21"
      }
    ]
  }
  /*
   * Restricted network ranges
   */
  restricted_private_service_cidr = "10.24.64.0/21"
  restricted_subnet_primary_ranges = {
    (local.default_region1) = "10.8.64.0/21"
    (local.default_region2) = "10.9.64.0/21"
  }
  restricted_subnet_secondary_ranges = {
    (local.default_region1) = [
      {
        range_name    = "rn-${local.environment_code}-shared-restricted-${local.default_region1}-gke-pod"
        ip_cidr_range = "100.72.64.0/21"
      },
      {
        range_name    = "rn-${local.environment_code}-shared-restricted-${local.default_region1}-gke-svc"
        ip_cidr_range = "100.72.72.0/21"
      }
    ]
  }
}

module "base_env" {
  source = "../../modules/base_env"

  env                                = local.env
  environment_code                   = local.environment_code
  org_id                             = var.org_id
  access_context_manager_policy_id   = var.access_context_manager_policy_id
  terraform_service_account          = var.terraform_service_account
  default_region1                    = local.default_region1
  default_region2                    = local.default_region2
  domain                             = var.domain
  parent_folder                      = var.parent_folder
  enable_partner_interconnect        = false
  enable_hub_and_spoke_transitivity  = var.enable_hub_and_spoke_transitivity
  base_private_service_cidr          = local.base_private_service_cidr
  base_subnet_primary_ranges         = local.base_subnet_primary_ranges
  base_subnet_secondary_ranges       = local.base_subnet_secondary_ranges
  restricted_private_service_cidr    = local.restricted_private_service_cidr
  restricted_subnet_primary_ranges   = local.restricted_subnet_primary_ranges
  restricted_subnet_secondary_ranges = local.restricted_subnet_secondary_ranges

}