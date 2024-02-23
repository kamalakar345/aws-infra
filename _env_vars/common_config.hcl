locals{
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Common variable reference comming from common_config.hcl 
  region                                  = "us-west-2"
  admin_contact                           = "aware.cloud.eng.devops@quicinc.com"
  service_id                              = "AWARE"
  aws_account                             = 566323384327
  aware_services                          = ["analytic-processor", "aware_common", "aware-common-ui", "aware-core", "aware-mock-api", "aware-notification-engine", "aware-operational-portal-ui", "aware-public-ui", "aware-publicapi-documentation", "aware-rule-engine", "aware-service-dashboard-ui", "aware-session-manager", "builder-service", "coap-client", "coap-client-dtls", "coap-protocol-adaptor", "coap-protocol-adaptor-dtls", "command-service-aware", "docsapi", "feedback-service", "global-settings-service", "inclinometer-processor", "inclinometer-service", "location-service", "logstash-aware", "mockpublicapi", "msgdispatcher-pro-aware", "notification-service-aware", "nucleus_dm", "nucleus_dm-consumer", "nucleus_um", "playground-proxy", "profile-service-aware", "prom/blackbox-exporter", "public-ui", "route-config-api-aware", "rule-definition-service", "sensor-service-aware", "shadow-service", "shipment-processor", "swagger-common-ui", "telemetry-engine-aware", "telemetry-service-aware", "tenant-service-aware", "test-awarepublicapi", "tracker-service-aware", "tracker-shipment-service", "xns-service", "saga-um-global"]
# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = "vpc-04afd173a696245b1"
  reg_priv_private_subnet_ids             = ["subnet-0941c676485a06137", "subnet-01b72b7b92a82fe59"] //privateA and privateB

## Reg Public VPC Details

  reg_pub_vpc_id                          = "vpc-0ab7f3268a0718551" // Public VPC-ID
  reg_pub_private_subnet_ids              = ["subnet-06e4839cc38c5616c", "subnet-0b5a8ddebdca6f07b"] //Public VPC-ID privateA and privateB

## Global Private VPC Details
  glb_priv_vpc_id                         = "vpc-09880462f53024971"
  glb_priv_private_subnet_ids             = ["subnet-0f84a41f151e57595", "subnet-0b3f58f8aab5f33a1"] //privateA and privateB

## Global Public VPC Details
  glb_pub_vpc_id                          = "vpc-03d8ca1ae57e06cb1" // Public VPC-ID
  glb_pub_private_subnet_ids              = ["subnet-012c9a9a6ba42d91b", "subnet-0c39d78683642f719"] // [Public-privateA, Public-privateB]

## quicksite Details
   quicksight_enabled                     = true
   admin_user                             = ["choudha@qti.qualcomm.com", "aygu@qti.qualcomm.com", "kmalugul@quicinc.com"]
   quicksight_email                       = "choudha@qti.qualcomm.com"

}